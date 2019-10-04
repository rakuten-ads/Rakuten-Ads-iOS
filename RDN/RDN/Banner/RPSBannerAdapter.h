//
//  RPSBannerAdapter.h
//  RDN
//
//  Created by Wu, Wei b on 2019/02/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSBidAdapter.h"
#import "RPSURLString.h"

NS_ASSUME_NONNULL_BEGIN
@interface RPSBanner : NSObject<RPSAdInfo>

@property(nonatomic, readonly) NSString* html;
@property(nonatomic, readonly) float width;
@property(nonatomic, readonly) float height;

@property(nonatomic, readonly) RPSURLString* measuredURL;
@property(nonatomic, readonly) RPSURLString* inviewURL;

-(void)parse:(NSDictionary *)bidData;

@end


@interface RPSBannerAdapter : RPSBidAdapter

@property(nonatomic, copy) NSString* adspotId;

@end

NS_ASSUME_NONNULL_END
