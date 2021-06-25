//
//  RUNANativeAdInner.h
//  RUNA
//
//  Created by Wu, Wei b on 2019/03/20.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUNACore/RUNAJSONObject.h>
#import <RUNACore/RUNABidAdapter.h>
#import "RUNANativeAd.h"
#import <RUNACore/RUNAURLString.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Asset Data Structures
// parent
@interface RUNANativeAdAsset()

-(void) parse:(RUNAJSONObject*) assetJson;

+(instancetype) factoryAsset:(NSDictionary*) assetJson;

@end

// title
@interface RUNANativeAdAssetTitle : RUNANativeAdAsset

@property(nonatomic, readonly) NSString* text;

@end

// image
typedef NS_ENUM(NSUInteger, RUNANativeAdAssetImageType) {
    RUNANativeAdAssetImageTypeIcon = 1,
    RUNANativeAdAssetImageTypeMain = 3,
    RUNANativeAdAssetImageTypeOther = 500,
};

@interface RUNANativeAdAssetImage()

@property(nonatomic, readonly) int type;

@end

// video
@interface RUNANativeAdAssetVideo : RUNANativeAdAsset

@property(nonatomic, readonly) NSString* vasttag;

@end

typedef NS_ENUM(NSUInteger, RUNANativeAdAssetDataType) {
    RUNANativeAdAssetDataTypeSponsored = 1,
    RUNANativeAdAssetDataTypeDesc,
    RUNANativeAdAssetDataTypeRating,
    RUNANativeAdAssetDataTypePrice,
    RUNANativeAdAssetDataTypeSaleprice,
    RUNANativeAdAssetDataTypeCtatext,
    RUNANativeAdAssetDataTypeOther = 500,
};


// link
@interface RUNANativeAdAssetLink: RUNANativeAdAsset<RUNAHttpTaskDelegate>

@property(nonatomic, readonly) NSString* url;
@property(nonatomic, readonly, nullable) NSArray<NSString*>* clicktrackers;
@property(nonatomic, readonly, nullable) NSString* fallback;

@end

// event tracker
typedef NS_ENUM(NSUInteger, RUNANativeAdEventTrackerType) {
    RUNANativeAdEventTrackerTypeImpression = 1,
    RUNANativeAdEventTrackerTypeViewableMrc50,
    RUNANativeAdEventTrackerTypeViewableMrc100,
    RUNANativeAdEventTrackerTypeViewableVideo50,
    RUNANativeAdEventTrackerTypeViewableOther = 500,
};

typedef NS_ENUM(NSUInteger, RUNANativeAdEventTrackerMethod) {
    RUNANativeAdEventTrackerMethodImg = 1,
    RUNANativeAdEventTrackerMethodJs,
    RUNANativeAdEventTrackerMethodOther = 500,
};

@interface RUNANativeAdEventTracker: NSObject<RUNAHttpTaskDelegate>

@property(nonatomic, readonly) int event;
@property(nonatomic, readonly) int method;
@property(nonatomic, readonly) RUNAURLString* url;

-(void) parse:(RUNAJSONObject*) assetJson;

@end


#pragma mark -
#pragma mark United Object


@interface RUNANativeAd()<RUNAAdInfo>

// protected
@property(nonatomic, nullable) RUNANativeAdAssetTitle* assetTitle;
@property(nonatomic, nullable) NSArray<RUNANativeAdAssetData*>* assetDatas;
@property(nonatomic, nullable) NSArray<RUNANativeAdAssetImage*>* assetImgs;
@property(nonatomic, nullable) RUNANativeAdAssetVideo* assetVideo;

@property(nonatomic, nullable) RUNANativeAdAssetLink* assetLink;
@property(nonatomic, nullable) NSArray<RUNANativeAdEventTracker*>* eventTrackers;

/**
 * help method to convert one bid json to one RUNANativeAd
 */
+(instancetype)parse:(NSDictionary *)bidData;

@end



NS_ASSUME_NONNULL_END
