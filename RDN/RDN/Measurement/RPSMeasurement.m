//
//  RPSMeasurement.m
//  RDN
//
//  Created by Wu, Wei b on 2019/08/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSMeasurement.h"

NSTimeInterval kIntervalInView = 1;

@implementation RPSMeasurement

-(void)startMeasurement {
    RPSDebug("startMeasurement");
    [self.measurableTarget measureImp];

    __weak RPSMeasurement* weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kIntervalInView * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf && weakSelf.measurableTarget) {
            [weakSelf.measurableTarget measureInview];
        } else {
            RPSDebug("adview disposed!");
        }
    });
}

@end
