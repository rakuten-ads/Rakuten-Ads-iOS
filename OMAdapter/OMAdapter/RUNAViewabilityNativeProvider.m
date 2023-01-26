//
//  RUNAViewabilityNativeProvider.m
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/25.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import "RUNAViewabilityNativeProvider.h"
@interface RUNAViewabilityNativeProvider()

@property(nonatomic, weak, nullable) UIView* targetView;

@end

@implementation RUNAViewabilityNativeProvider

-(void)registerTargetView:(UIView *)view {
    self.targetView = view;

}

- (void)unregisterTargetView:(UIView *)view {
    self.targetView = nil;
}

@end
