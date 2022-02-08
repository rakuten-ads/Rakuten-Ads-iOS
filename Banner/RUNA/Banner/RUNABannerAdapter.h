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

@property(nonatomic, readonly) NSString* impId;
@property(nonatomic, readonly) NSString* html;
@property(nonatomic, readonly) float width;
@property(nonatomic, readonly) float height;

@property(nonatomic, readonly, nullable) RUNAURLString* measuredURL;
@property(nonatomic, readonly, nullable) RUNAURLString* inviewURL;
@property(nonatomic, readonly, nullable) NSString* viewabilityProviderURL;
@property(nonatomic, readonly) NSInteger advertiseId;


-(void)parse:(NSDictionary *)bidData;

@end

@interface RUNAGeo : NSObject
@property(nonatomic) double latitude;
@property(nonatomic) double longitude;
@end

@interface RUNABannerImp : NSObject

@property(nonatomic) NSString* id;
@property(nonatomic) NSString* adspotId;
@property(nonatomic) NSMutableDictionary* json;
@property(nonatomic) NSDictionary* banner;
@end

@interface RUNABannerAdapter : RUNABidAdapter

@property(nonatomic) NSArray<RUNABannerImp*>* impList;
@property(nonatomic) NSDictionary* appContent;
@property(nonatomic) NSString* userId;
@property(nonatomic) NSDictionary* userExt;
@property(nonatomic) RUNAGeo* geo;
@property(nonatomic) NSArray* blockAdList;

@end

NS_ASSUME_NONNULL_END
