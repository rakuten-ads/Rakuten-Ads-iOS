//
//  RUNANativeAd.h
//  RDN
//
//  Created by Wu, Wei b on 2019/03/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Native Ads structs
@interface RUNANativeAdAsset: NSObject

@property(nonatomic, readonly, getter=isRequired) Boolean required;

@end

@interface RUNANativeAdAssetImage: RUNANativeAdAsset

@property(nonatomic, readonly) NSString* url;
@property(nonatomic, readonly) int w;
@property(nonatomic, readonly) int h;

@end

// data
@interface RUNANativeAdAssetData : RUNANativeAdAsset

@property(nonatomic, readonly) NSString* value;
@property(nonatomic, readonly) int type;
@property(nonatomic, readonly) int len;
@property(nonatomic, readonly, nullable) NSDictionary* ext;

@end

// united ads
@interface RUNANativeAd : NSObject

@property(nonatomic, readonly, nullable) NSString* title;
@property(nonatomic, readonly, nullable) NSString* desc;
@property(nonatomic, readonly, nullable) RUNANativeAdAssetImage* iconImg;
@property(nonatomic, readonly, nullable) RUNANativeAdAssetImage* mainImg;
@property(nonatomic, readonly, nullable) NSString* privacyURL;

@property(nonatomic, readonly, nullable) NSString* price;
@property(nonatomic, readonly, nullable) NSString* salePrice;
@property(nonatomic, readonly, nullable) NSString* ctatext;
@property(nonatomic, readonly, nullable) NSString* sponsor;
@property(nonatomic, readonly, nullable) NSNumber* rating;
@property(nonatomic, readonly, nullable) NSArray<RUNANativeAdAssetData*>* specificData;

@property(nonatomic, readonly, nullable) NSDictionary* ext;

-(void) fireClick;
-(void) fireImpression;

@property(nonatomic, readonly) NSDictionary* rawData;

@end

# pragma mark - Ad Provider

@interface RUNANativeAdProvider: NSObject

@property(nonatomic, copy, nonnull) NSString* adSpotId;

-(instancetype) initWithAdSpotId:(NSString*) adSpotId;

-(instancetype) init NS_UNAVAILABLE;
+(instancetype) new NS_UNAVAILABLE;

-(void) loadWithCompletionHandler:(nullable void (^)(RUNANativeAdProvider* provider, NSArray<RUNANativeAd*>* adsList)) handler;

@end

NS_ASSUME_NONNULL_END
