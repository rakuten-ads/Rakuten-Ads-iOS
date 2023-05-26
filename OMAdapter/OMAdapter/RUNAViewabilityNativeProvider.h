//
//  RUNAViewabilityNativeProvider.h
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/25.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <RUNABanner/RUNAViewabilityProvider.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAViewabilityNativeProvider : NSObject

-(void) registerTargetView:(UIView*) view withViewImpURL:(nullable NSString*) url completionHandler:(nullable RUNAViewabilityCompletionHandler) handler;

-(void) unregisterTargetView:(UIView*) view;

@end

NS_ASSUME_NONNULL_END
