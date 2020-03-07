//
//  RPSMeasurement.m
//  RDN
//
//  Created by Wu, Wei b on 2019/08/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSMeasurement.h"

NSTimeInterval kMeasureIntervalInView = 1;

@interface RPSDefaultMeasurer()

@property(nonatomic, weak, nullable) id<RPSDefaultMeasurement> measurableTarget;

@property(atomic) BOOL shouldStopMeasureImp;
@property(atomic) BOOL shouldStopMeasureInview;

@end

@implementation RPSDefaultMeasurer

+(NSOperationQueue*) sharedQueue {
    static dispatch_once_t onceToken;
    static NSOperationQueue* queue;
    dispatch_once(&onceToken, ^{
        queue = [NSOperationQueue new];
    });
    return queue;
}

-(void)main {
    RPSDebug("measurement inview dequeue");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMeasureIntervalInView * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @try {
            if (self.measurableTarget) {
                self.shouldStopMeasureInview = self.shouldStopMeasureInview || [self.measurableTarget measureInview];
                RPSDebug("measurement inview : %@", self.shouldStopMeasureInview ? @"stopped" : @"continue...");
                if (!self.shouldStopMeasureInview) {
                    RPSDebug("measurement inview enqueue again");
                    RPSDefaultMeasurer* repeatingOperation = [self clone];
                    [[RPSDefaultMeasurer sharedQueue] addOperation:repeatingOperation];
                }
            } else {
                RPSDebug("measurable target disposed!");
            }
        } @catch (NSException *exception) {
            RPSDebug("Measurement Operation exception: %@", exception);
        }
    });
}

-(instancetype) clone {
    RPSDefaultMeasurer* repeatOperation = [RPSDefaultMeasurer new];
    repeatOperation.measurableTarget = self.measurableTarget;
    repeatOperation.shouldStopMeasureImp = self.shouldStopMeasureImp;
    repeatOperation.shouldStopMeasureInview = self.shouldStopMeasureInview;
    return repeatOperation;
}

-(void)startMeasurement {
    RPSDebug("startMeasurement");
    self.shouldStopMeasureImp = self.shouldStopMeasureImp || [self.measurableTarget measureImp];
    RPSDebug("measurement imp : %@", self.shouldStopMeasureImp ? @"stopped" : @"continue...");

    if (!self.shouldStopMeasureInview) {
        RPSDebug("measurement inview enqueue");
        [[RPSDefaultMeasurer sharedQueue] addOperation:self];
    }
}

-(void)finishMeasurement {
    if (!self.isCancelled) {
        [self cancel];
    }
}

-(void)setMeasureTarget:(id<RPSDefaultMeasurement>)measurableTarget {
    self.measurableTarget = measurableTarget;
}
@end
