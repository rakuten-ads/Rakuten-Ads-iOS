//
//  RPSNativeAd.h
//  RDN
//
//  Created by Wu, Wei b on 2019/03/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Native Ads
@interface RPSNativeAdAsset: NSObject

@property(nonatomic, readonly, getter=isRequired) Boolean required;

@end

@interface RPSNativeAdAssetImage: RPSNativeAdAsset

@property(nonatomic, readonly) NSString* url;
@property(nonatomic, readonly) int w;
@property(nonatomic, readonly) int h;

@end

// united ads
@interface RPSNativeAd : NSObject

@property(nonatomic, readonly, nullable) NSString* title;
@property(nonatomic, readonly, nullable) NSString* desc;
@property(nonatomic, readonly, nullable) RPSNativeAdAssetImage* iconImg;
@property(nonatomic, readonly, nullable) RPSNativeAdAssetImage* mainImg;
@property(nonatomic, readonly, nullable) NSString* privacyURL;

@property(nonatomic, readonly, nullable) NSString* price;
@property(nonatomic, readonly, nullable) NSString* salePrice;
@property(nonatomic, readonly, nullable) NSString* callToActionURL;
@property(nonatomic, readonly, nullable) NSString* sponsor;
@property(nonatomic, readonly) unsigned int rating;

@property(nonatomic, readonly, nullable) NSDictionary* ext;

-(void) fireClick;
-(void) fireImpression;

@property(nonatomic, readonly) NSDictionary* rawData;

@end

@interface RPSNativeAdProvider: NSObject

@property(nonatomic, copy, nonnull) NSString* adSpotId;

-(instancetype) initWithAdSpotId:(NSString*) adSpotId;

-(instancetype) init NS_UNAVAILABLE;
+(instancetype) new NS_UNAVAILABLE;

-(void) loadWithCompletionHandler:(nullable BOOL (^)(RPSNativeAdProvider* provider, NSArray<RPSNativeAd*>* adsList)) handler;

@end

NS_ASSUME_NONNULL_END
