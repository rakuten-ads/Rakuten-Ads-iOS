//
//  RUNAMeasurement.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/08/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNAMeasurement.h"
#import "RUNABannerViewInner.h"

NSTimeInterval kMeasureIntervalInView = 1;
int kMeasureMaxCount = 600;

@interface RUNADefaultMeasureOption : NSOperation

@property(nonatomic, weak) RUNADefaultMeasurer* measurer;

@end

@interface RUNADefaultMeasurer()

@property(nonatomic, weak, nullable) id<RUNADefaultMeasurement> measurableTarget;
@property(nonatomic) int countDown;

@property(atomic) BOOL shouldStopMeasureImp;
@property(atomic) BOOL shouldStopMeasureInview;

@end

# pragma mark - RUNADefaultMeasurer

@implementation RUNADefaultMeasurer

@synthesize viewableObserverDelegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.countDown = kMeasureMaxCount;
    }
    return self;
}

+ (NSOperationQueue*)sharedQueue {
    static dispatch_once_t onceToken;
    static NSOperationQueue* queue;
    dispatch_once(&onceToken, ^{
        queue = [NSOperationQueue new];
    });
    return queue;
}

- (void)startMeasurement {
    RUNADebug("measurement[default] start on target %p", self.measurableTarget);
    self.shouldStopMeasureImp = self.shouldStopMeasureImp || [self.measurableTarget measureImp];
    RUNADebug("measurement[default] target %p imp : %@", self.measurableTarget, self.shouldStopMeasureImp ? @"stopped" : @"continue...");

    if (!self.shouldStopMeasureInview) {
        RUNADefaultMeasureOption* operation = [RUNADefaultMeasureOption new];
        operation.measurer = self;
        RUNADebug("measurement[default] target %p inview %p enqueue", self.measurableTarget, operation);
        [[RUNADefaultMeasurer sharedQueue] addOperation:operation];
    }
}

- (void)finishMeasurement {
    RUNADebug("measurement[default] finish on target %p", self.measurableTarget);
    self.shouldStopMeasureInview = YES;
    self.shouldStopMeasureImp = YES;
}

- (void)setMeasureTarget:(id<RUNADefaultMeasurement>)measurableTarget {
    self.measurableTarget = measurableTarget;
}
@end

# pragma mark - RUNADefaultMeasureOption
@implementation RUNADefaultMeasureOption

- (void)main {
    RUNADebug("measurement[default] inview %p dequeue", self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMeasureIntervalInView * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try {
            RUNADefaultMeasurer* measurer = self.measurer;
            if (measurer.measurableTarget) {
                BOOL measureInview = [measurer.measurableTarget measureInview];
                [self executeInviewObserver:measurer measureInview:measureInview];
                measurer.shouldStopMeasureInview = measurer.shouldStopMeasureInview || measureInview;
                if (!measurer.shouldStopMeasureInview && measurer.countDown > 0) {
                    RUNADebug("measurement[default] inview : %@", @"continue...");
                    RUNADefaultMeasureOption* operation = [RUNADefaultMeasureOption new];
                    measurer.countDown--;
                    operation.measurer = measurer;
                    RUNADebug("measurement[default] inview enqueue %p again", operation);
                    [[RUNADefaultMeasurer sharedQueue] addOperation:operation];
                } else {
                    RUNADebug("measurement[default] inview stopped by [should=%@ & countDown=%d]", measurer.shouldStopMeasureInview ? @"YES" : @"NO", measurer.countDown);
                }
            } else {
                RUNADebug("measurement[default] target %p disposed!", measurer.measurableTarget);
            }
        } @catch (NSException *exception) {
            RUNADebug("measurement[default] operation exception: %@", exception);
            [self sendRemoteLogWithMessage:@"measurement[default] operation exception" andException:exception];
        }
    });
}

- (void)executeInviewObserver:(RUNADefaultMeasurer*)measurer
                measureInview:(BOOL)measureInview {
    id<RUNAViewableObserverDelegate> delegate = measurer.viewableObserverDelegate;
    if (delegate && [delegate respondsToSelector:@selector(didMeasurementInView:)]) {
        [delegate didMeasurementInView:measureInview];
    }
}

- (void)sendRemoteLogWithMessage:(NSString*) message andException:(NSException*) exception {
    if ([self.measurer.measurableTarget isKindOfClass:[RUNABannerView class]]) {
        [(RUNABannerView*)self.measurer.measurableTarget sendRemoteLogWithMessage:message andException:exception];
    }
}

@end
