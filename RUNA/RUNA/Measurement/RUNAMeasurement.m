//
//  RUNAMeasurement.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/08/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNAMeasurement.h"

NSTimeInterval kMeasureIntervalInView = 1;

@interface RUNADefaultMeasurer()

@property(nonatomic, weak, nullable) id<RUNADefaultMeasurement> measurableTarget;

@property(atomic) BOOL shouldStopMeasureImp;
@property(atomic) BOOL shouldStopMeasureInview;

@end

@implementation RUNADefaultMeasurer

+(NSOperationQueue*) sharedQueue {
    static dispatch_once_t onceToken;
    static NSOperationQueue* queue;
    dispatch_once(&onceToken, ^{
        queue = [NSOperationQueue new];
    });
    return queue;
}

-(void)main {
    RUNADebug("measurement inview dequeue");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMeasureIntervalInView * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try {
            if (self.measurableTarget) {
                self.shouldStopMeasureInview = self.shouldStopMeasureInview || [self.measurableTarget measureInview];
                RUNADebug("measurement inview : %@", self.shouldStopMeasureInview ? @"stopped" : @"continue...");
                if (!self.shouldStopMeasureInview) {
                    RUNADebug("measurement inview enqueue again");
                    RUNADefaultMeasurer* repeatingOperation = [self clone];
                    [[RUNADefaultMeasurer sharedQueue] addOperation:repeatingOperation];
                }
            } else {
                RUNADebug("measurable target disposed!");
            }
        } @catch (NSException *exception) {
            RUNADebug("Measurement Operation exception: %@", exception);
        }
    });
}

-(instancetype) clone {
    RUNADefaultMeasurer* repeatOperation = [RUNADefaultMeasurer new];
    repeatOperation.measurableTarget = self.measurableTarget;
    repeatOperation.shouldStopMeasureImp = self.shouldStopMeasureImp;
    repeatOperation.shouldStopMeasureInview = self.shouldStopMeasureInview;
    return repeatOperation;
}

-(void)startMeasurement {
    RUNADebug("startMeasurement");
    self.shouldStopMeasureImp = self.shouldStopMeasureImp || [self.measurableTarget measureImp];
    RUNADebug("measurement imp : %@", self.shouldStopMeasureImp ? @"stopped" : @"continue...");

    if (!self.shouldStopMeasureInview) {
        RUNADebug("measurement inview enqueue");
        [[RUNADefaultMeasurer sharedQueue] addOperation:self];
    }
}

-(void)finishMeasurement {
    RUNADebug("finishMeasurement");
    if (!self.isCancelled) {
        [self cancel];
    }
}

-(void)setMeasureTarget:(id<RUNADefaultMeasurement>)measurableTarget {
    self.measurableTarget = measurableTarget;
}
@end
