//
//  RUNAMeasurement.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/08/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNAMeasurement.h"
#import "RUNABannerViewInner.h"

NSTimeInterval kMeasureIntervalInview = 1;
NSTimeInterval kMeasureIntervalVideoTrack = 0.1;
int kMeasureMaxCount = 600;

@interface RUNADefaultMeasureOperation : NSOperation

@property(nonatomic, weak) RUNADefaultMeasurer* measurer;

@end

@interface RUNAVideoTrackOperation : RUNADefaultMeasureOperation

@end

# pragma mark - RUNADefaultMeasurer

@interface RUNADefaultMeasurer()

@property(nonatomic, weak, nullable) id<RUNADefaultMeasurement> measurableTarget;
@property(nonatomic, weak, nullable) id<RUNAMeasurerDelegate> measurerDelegate;
@property(nonatomic) int countDown;

@property(atomic) BOOL shouldStopMeasureImp;
@property(atomic) BOOL shouldStopMeasureInview;


@end

@implementation RUNADefaultMeasurer

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
    self.shouldStopMeasureImp = self.shouldStopMeasureImp || [self executeMeasureImp];

    RUNADebug("measurement[default] target %p imp : %@", self.measurableTarget, self.shouldStopMeasureImp ? @"stopped" : @"continue...");

    if (!self.shouldStopMeasureInview) {
        RUNADefaultMeasureOperation* operation = [RUNADefaultMeasureOperation new];
        operation.measurer = self;
        RUNADebug("measurement[default] target %p inview %p enqueue", self.measurableTarget, operation);
        [[RUNADefaultMeasurer sharedQueue] addOperation:operation];
    }

    if (self.isVideoTrack) {
        RUNAVideoTrackOperation* operation = [RUNAVideoTrackOperation new];
        operation.measurer = self;
        RUNADebug("measurement[video track] target %p inview %p enqueue", self.measurableTarget, operation);
        [[RUNADefaultMeasurer sharedQueue] addOperation:operation];
    }
}

- (void)finishMeasurement {
    RUNADebug("measurement[default] finish on target %p", self.measurableTarget);
    self.shouldStopMeasureInview = YES;
    self.shouldStopMeasureImp = YES;
}

- (void)setMeasureTarget:(id<RUNADefaultMeasurement>)measurableTarget {
    self->_measurableTarget = measurableTarget;
}

- (void)setMeasurerDelegate:(id<RUNAMeasurerDelegate>)measurerDelegate {
    self->_measurerDelegate = measurerDelegate;
}


-(BOOL) executeMeasureImp {
    BOOL isImp = [self.measurableTarget measureImp];
    if (self.measurerDelegate && [self.measurerDelegate respondsToSelector:@selector(didMeasureImp:)]) {
        RUNADebug("measurement[default] invoke measure imp delegate");
        return [self.measurerDelegate didMeasureImp:isImp];
    }
    RUNADebug("measurement[default] measure imp result: %@", isImp ? @"YES" : @"NO");
    return isImp;
}

@end

# pragma mark - RUNADefaultMeasureOption
@implementation RUNADefaultMeasureOperation

- (void)main {
    RUNADebug("measurement[default] measure inview %p dequeue", self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMeasureIntervalInview * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try {
            RUNADefaultMeasurer* measurer = self.measurer;
            if (measurer.measurableTarget) {
                measurer.shouldStopMeasureInview = measurer.shouldStopMeasureInview || [self executeMeasureInview];
                if (!measurer.shouldStopMeasureInview && measurer.countDown > 0) {
                    RUNADebug("measurement[default] inview : %@", @"continue...");
                    RUNADefaultMeasureOperation* operation = [RUNADefaultMeasureOperation new];
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

- (BOOL) executeMeasureInview {
    RUNADebug("measurement[default] measure in view");
    BOOL isInview = [self.measurer.measurableTarget measureInview];
    id<RUNAMeasurerDelegate> delegate = self.measurer.measurerDelegate;
    if (delegate && [delegate respondsToSelector:@selector(didMeasureInview:)]) {
        RUNADebug("measurement[default] invoke didMeasureInview delegate");
        return [delegate didMeasureInview:isInview];
    } else {
        RUNADebug("measurement[default] measure in view result: %@", isInview ? @"YES" : @"NO");
        return isInview;
    }
}

- (void)sendRemoteLogWithMessage:(NSString*) message andException:(NSException*) exception {
    if ([self.measurer.measurableTarget isKindOfClass:[RUNABannerView class]]) {
        [(RUNABannerView*)self.measurer.measurableTarget sendRemoteLogWithMessage:message andException:exception];
    }
}

@end


# pragma mark - Video Track
@implementation RUNAVideoTrackOperation

-(void)main {
    RUNADebug("measurement[video track] measure inview %p dequeue", self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMeasureIntervalVideoTrack * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try {
            RUNADefaultMeasurer* measurer = self.measurer;
            if (measurer.measurableTarget) {
                [self executeMeasureVideo];

                RUNAVideoTrackOperation* operation = [RUNAVideoTrackOperation new];
                operation.measurer = measurer;
                RUNADebug("measurement[video track] inview enqueue %p again", operation);
                [[RUNADefaultMeasurer sharedQueue] addOperation:operation];
            } else {
                RUNADebug("measurement[video track] target %p disposed!", measurer.measurableTarget);
            }
        } @catch (NSException *exception) {
            RUNADebug("measurement[video track] operation exception: %@", exception);
            [self sendRemoteLogWithMessage:@"measurement[video track] operation exception" andException:exception];
        }
    });
}

- (void) executeMeasureVideo {
    RUNADebug("measurement[video track] measure in view");
    BOOL isInview = [self.measurer.measurableTarget measureInview];
    id<RUNAMeasurerDelegate> delegate = self.measurer.measurerDelegate;
    if (delegate && [delegate respondsToSelector:@selector(didMeasureVideoTrack:)]) {
        RUNADebug("measurement[video track] invoke didMeasureVideoTrack delegate");
        [delegate didMeasureVideoTrack:isInview];
    }
}

@end
