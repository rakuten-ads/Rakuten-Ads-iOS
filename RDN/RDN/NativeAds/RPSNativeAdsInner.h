//
//  RPSNativeAdsInner.h
//  RDN
//
//  Created by Wu, Wei b on 2019/03/20.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSNativeAds.h"
#import "RPSBidAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPSNativeAds()<RPSAdInfo>

/**
 * help method to convert one bid json to one RPSNativeAds
 */
+(instancetype)parse:(NSDictionary *)bidData;

@end

NS_ASSUME_NONNULL_END
