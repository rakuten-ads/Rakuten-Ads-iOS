//
//  RUNAViewabilityNativeProvider.h
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/25.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAViewabilityNativeProvider : NSObject

-(void) registerTargetView:(UIView*) view;

-(void) unregisterTargetView:(UIView*) view;

@end

NS_ASSUME_NONNULL_END
