//
//  RPSMeasurement.m
//  RDN
//
//  Created by Wu, Wei b on 2019/08/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSMeasurement.h"

@implementation RPSMeasurement

-(void)startMeasurement {
    RPSDebug("startMeasurement");
    [self.measurableTarget measureImp];

    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(afterOneSecond:) userInfo:nil repeats:false];
}

-(void) afterOneSecond:(NSTimer*) timer {
    RPSDebug("measurement in 1 Second");

    [self.measurableTarget measureInview];
}

@end
