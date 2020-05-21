//
//  RUNABannerAdapter.h
//  RUNA
//
//  Created by Wu, Wei b on 2019/02/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUNACore/RUNABidAdapter.h>
#import <RUNACore/RUNAURLString.h>

NS_ASSUME_NONNULL_BEGIN
@interface RUNABanner : NSObject<RUNAAdInfo>

@property(nonatomic, readonly) NSString* html;
@property(nonatomic, readonly) float width;
@property(nonatomic, readonly) float height;

@property(nonatomic, readonly) RUNAURLString* measuredURL;
@property(nonatomic, readonly) RUNAURLString* inviewURL;

-(void)parse:(NSDictionary *)bidData;

@end


@interface RUNABannerAdapter : RUNABidAdapter

@property(nonatomic, copy) NSString* adspotId;
@property(nonatomic) NSDictionary* json;
@property(nonatomic) NSDictionary* appContent;

@end

NS_ASSUME_NONNULL_END
