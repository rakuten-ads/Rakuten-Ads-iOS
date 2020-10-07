//
//  RUNAMeasurement.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/08/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNAMeasurement.h"

NSTimeInterval kMeasureIntervalInView = 1;

@interface RUNADefaultMeasureOption : NSOperation

@property(nonatomic, weak) RUNADefaultMeasurer* measurer;

@end

@interface RUNADefaultMeasurer()

@property(nonatomic, weak, nullable) id<RUNADefaultMeasurement> measurableTarget;

@property(atomic) BOOL shouldStopMeasureImp;
@property(atomic) BOOL shouldStopMeasureInview;

@end

# pragma mark - RUNADefaultMeasurer

@implementation RUNADefaultMeasurer

+(NSOperationQueue*) sharedQueue {
    static dispatch_once_t onceToken;
    static NSOperationQueue* queue;
    dispatch_once(&onceToken, ^{
        queue = [NSOperationQueue new];
    });
    return queue;
}

-(void)startMeasurement {
    RUNADebug("measurement[default] start");
    self.shouldStopMeasureImp = self.shouldStopMeasureImp || [self.measurableTarget measureImp];
    RUNADebug("measurement[default] imp : %@", self.shouldStopMeasureImp ? @"stopped" : @"continue...");

    if (!self.shouldStopMeasureInview) {
        RUNADefaultMeasureOption* operation = [RUNADefaultMeasureOption new];
        operation.measurer = self;
        RUNADebug("measurement[default] inview %p enqueue", operation);
        [[RUNADefaultMeasurer sharedQueue] addOperation:operation];
    }
}

-(void)finishMeasurement {
    RUNADebug("measurement[default] finish");
    self.shouldStopMeasureInview = YES;
    self.shouldStopMeasureImp = YES;
}

-(void)setMeasureTarget:(id<RUNADefaultMeasurement>)measurableTarget {
    self.measurableTarget = measurableTarget;
}
@end

# pragma mark - RUNADefaultMeasureOption
@implementation RUNADefaultMeasureOption

-(void)main {
    RUNADebug("measurement[default] inview %p dequeue", self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMeasureIntervalInView * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try {
            RUNADefaultMeasurer* measurer = self.measurer;
            if (measurer.measurableTarget) {
                measurer.shouldStopMeasureInview = measurer.shouldStopMeasureInview || [measurer.measurableTarget measureInview];
                RUNADebug("measurement[default] inview : %@", measurer.shouldStopMeasureInview ? @"stopped" : @"continue...");
                if (!measurer.shouldStopMeasureInview) {
                    RUNADefaultMeasureOption* operation = [RUNADefaultMeasureOption new];
                    operation.measurer = measurer;
                    RUNADebug("measurement[default] inview enqueue %p again", operation);
                    [[RUNADefaultMeasurer sharedQueue] addOperation:operation];
                }
            } else {
                RUNADebug("measurement[default] target disposed!");
            }
        } @catch (NSException *exception) {
            RUNADebug("measurement[default] operation exception: %@", exception);
        }
    });
}
@end
