//
//  RUNAViewabilityNativeProvider.m
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/25.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import "RUNAViewabilityNativeProvider.h"
#import "RUNAOMNativeMeasurer.h"

@interface RUNAViewabilityNativeProvider()

@property(nonatomic, weak, nullable) UIView* targetView;
@property(nonatomic) RUNAOMNativeMeasurer* measurer;

@end

@implementation RUNAViewabilityNativeProvider

-(void) registerTargetView:(UIView*) view withViewImpURL:(nullable NSString*) url completionHandler:(nullable RUNAViewabilityCompletionHandler) handler {
    self.targetView = view;
    self.measurer = [RUNAOMNativeMeasurer new];
    [self.measurer setMeasureTarget: view];
    [self.measurer startMeasurement];
}

- (void)unregisterTargetView:(UIView *)view {
    self.targetView = nil;
    [self.measurer finishMeasurement];
}

@end
