//
//  RUNAViewabilityProvider.h
//  Banner
//
//  Created by Wu, Wei | David on 2021/05/26.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <RUNABanner/RUNAMeasurableTarget.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAViewabilityProvider : NSObject

+(instancetype) sharedInstance;

-(void) registerTarget:(RUNAMeasurableTarget*) target;
-(void) unregisterTarget:(RUNAMeasurableTarget*) target;

-(void) registerTargetView:(UIView*) view withViewImpURL:(nullable NSString*) url completionHandler:(nullable RUNAViewabilityCompletionHandler) handler DEPRECATED_MSG_ATTRIBUTE("Use -registerTarget:");

-(void) unregsiterTargetView:(UIView*) view DEPRECATED_MSG_ATTRIBUTE("Use -unregisterTargetView:");
-(void) unregisterTargetView:(UIView*) view;

@end

NS_ASSUME_NONNULL_END
