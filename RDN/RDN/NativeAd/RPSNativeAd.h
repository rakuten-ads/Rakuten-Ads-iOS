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
@property(nonatomic, readonly) double price;
@property(nonatomic, readonly) double salePrice;
@property(nonatomic, readonly, nullable) NSString* callToActionURL;
@property(nonatomic, readonly, nullable) NSString* sponsor;
@property(nonatomic, readonly) unsigned int rating;
@property(nonatomic, readonly, nullable) NSString* privacyURL;
@property(nonatomic, readonly, nullable) NSDictionary* ext;

@property(nonatomic, readonly) NSDictionary* rawData;

-(void) fireClick;
-(void) fireImpression;

@end

#pragma mark main API
@interface RPSNativeAdLoader: NSObject

@property(nonatomic, copy, nonnull) NSString* adSpotId;

-(void) loadWithCompletionHandler:(nullable BOOL (^)(RPSNativeAdLoader* loader, NSArray<RPSNativeAd*>* adsList)) handler;

@end



NS_ASSUME_NONNULL_END
