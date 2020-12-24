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

@property(nonatomic, readonly, nullable) RUNAURLString* measuredURL;
@property(nonatomic, readonly, nullable) RUNAURLString* inviewURL;
@property(nonatomic, readonly, nullable) NSString* viewabilityProviderURL;


-(void)parse:(NSDictionary *)bidData;

@end

@interface RUNAGeo : NSObject
@property(nonatomic) float latitude;
@property(nonatomic) float longitude;
@end

@interface RUNABannerAdapter : RUNABidAdapter

@property(nonatomic, copy) NSString* adspotId;
@property(nonatomic) NSDictionary* json;
@property(nonatomic) NSDictionary* appContent;
@property(nonatomic) NSDictionary* banner;
@property(nonatomic) NSDictionary* userExt;
@property(nonatomic) RUNAGeo* geo;

@end

NS_ASSUME_NONNULL_END
