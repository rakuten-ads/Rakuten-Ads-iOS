//
//  RPSNativeAds.h
//  RDN
//
//  Created by Wu, Wei b on 2019/03/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RPSNativeAdsAsset : NSObject

@property(nonatomic, readonly, getter=isRequired) Boolean required;

@end

typedef NS_ENUM(NSUInteger, RPSNativeAdsAssetImageType) {
    RPSNativeAdsAssetImageTypeIcon,
    RPSNativeAdsAssetImageTypeMain,
    RPSNativeAdsAssetImageTypeOther,
};

@interface RPSNativeAdsAssetImage : RPSNativeAdsAsset

@property(nonatomic, readonly) NSString* url;
@property(nonatomic, readonly) int w;
@property(nonatomic, readonly) int h;

@end

@interface RPSNativeAdsAssetTitle : RPSNativeAdsAsset

@property(nonatomic, readonly) NSString* text;
@property(nonatomic, readonly) int length;

@end

@interface RPSNativeAdsAssetData : RPSNativeAdsAsset

@property(nonatomic, readonly) NSString* value;

@end


@interface RPSNativeAdsEventTracker : NSObject

@property(nonatomic, readonly) int method;
@property(nonatomic, readonly) NSString* url;

@end

@interface RPSNativeAds : NSObject

@property(nonatomic, readonly, nullable) NSString* title;
@property(nonatomic, readonly, nullable) NSString* subTitle;
@property(nonatomic, readonly, nullable) NSArray<RPSNativeAdsAssetImage*>* imgs;
@property(nonatomic, readonly, nullable) NSString* value;

-(void) fireClick;
-(void) fireImpression;
-(void) showPrivacy;

@end

/**
 * raw assets data
 */
@interface RPSNativeAds()

@property(nonatomic, readonly, nullable) NSArray<RPSNativeAdsAsset*>* assets;

@end

@interface RPSNativeAdsLoader: NSObject

@property(nonatomic, copy, nonnull) NSString* adSpotId;

-(void) loadWithCompletionHandler:(nullable BOOL (^)(RPSNativeAdsLoader* loader, NSArray<RPSNativeAds*>* adsList)) handler;

@end

NS_ASSUME_NONNULL_END
