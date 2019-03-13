//
//  RPSBannerAdapter.h
//  RDN
//
//  Created by Wu, Wei b on 2019/02/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSBidAdapter.h"

NS_ASSUME_NONNULL_BEGIN
@interface RPSBanner : NSObject<RPSAdInfo>

@property(nonatomic, readonly) NSString* html;
@property(nonatomic, readonly) int width;
@property(nonatomic, readonly) int height;

+(instancetype)parse:(NSDictionary *)bidData;

@end


@interface RPSBannerAdapter : RPSBidAdapter

@property(nonatomic, copy) NSString* adspotId;

@end

NS_ASSUME_NONNULL_END
