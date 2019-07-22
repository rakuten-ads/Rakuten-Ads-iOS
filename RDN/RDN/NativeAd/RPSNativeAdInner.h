//
//  RPSNativeAdInner.h
//  RDN
//
//  Created by Wu, Wei b on 2019/03/20.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RPSCore/RPSJSONObject.h>
#import "RPSBidAdapter.h"
#import "RPSNativeAd.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Asset Data Structures
// parent
@interface RPSNativeAdAsset()

-(void) parse:(RPSJSONObject*) assetJson;

+(instancetype) factoryAsset:(NSDictionary*) assetJson;

@end

// title
@interface RPSNativeAdAssetTitle : RPSNativeAdAsset

@property(nonatomic, readonly) NSString* text;

@end

// image
typedef NS_ENUM(NSUInteger, RPSNativeAdAssetImageType) {
    RPSNativeAdAssetImageTypeIcon = 1,
    RPSNativeAdAssetImageTypeMain = 3,
    RPSNativeAdAssetImageTypeOther = 500,
};

@interface RPSNativeAdAssetImage()

@property(nonatomic, readonly) int type;

@end

// video
@interface RPSNativeAdAssetVideo : RPSNativeAdAsset

@property(nonatomic, readonly) NSString* vasttag;

@end

typedef NS_ENUM(NSUInteger, RPSNativeAdAssetDataType) {
    RPSNativeAdAssetDataTypeSponsored = 1,
    RPSNativeAdAssetDataTypeDesc,
    RPSNativeAdAssetDataTypeRating,
    RPSNativeAdAssetDataTypePrice,
    RPSNativeAdAssetDataTypeSaleprice,
    RPSNativeAdAssetDataTypeCtatext,
};


// link
@interface RPSNativeAdAssetLink: RPSNativeAdAsset<RPSHttpTaskDelegate>

@property(nonatomic, readonly) NSString* url;
@property(nonatomic, readonly, nullable) NSArray<NSString*>* clicktrackers;
@property(nonatomic, readonly, nullable) NSString* fallback;

@end

// event tracker
typedef NS_ENUM(NSUInteger, RPSNativeAdEventTrackerType) {
    RPSNativeAdEventTrackerTypeImpression = 1,
    RPSNativeAdEventTrackerTypeViewableMrc50,
    RPSNativeAdEventTrackerTypeViewableMrc100,
    RPSNativeAdEventTrackerTypeViewableVideo50,
    RPSNativeAdEventTrackerTypeViewableOther = 500,
};

typedef NS_ENUM(NSUInteger, RPSNativeAdEventTrackerMethod) {
    RPSNativeAdEventTrackerMethodImg = 1,
    RPSNativeAdEventTrackerMethodJs,
    RPSNativeAdEventTrackerMethodOther = 500,
};

@interface RPSNativeAdEventTracker: NSObject<RPSHttpTaskDelegate>

@property(nonatomic, readonly) int event;
@property(nonatomic, readonly) int method;
@property(nonatomic, readonly) NSString* url;

-(void) parse:(RPSJSONObject*) assetJson;

@end


#pragma mark -
#pragma mark United Object


@interface RPSNativeAd()<RPSAdInfo>

// protected
@property(nonatomic, nullable) RPSNativeAdAssetTitle* assetTitle;
@property(nonatomic, nullable) NSArray<RPSNativeAdAssetData*>* assetDatas;
@property(nonatomic, nullable) NSArray<RPSNativeAdAssetImage*>* assetImgs;
@property(nonatomic, nullable) RPSNativeAdAssetVideo* assetVideo;

@property(nonatomic, nullable) RPSNativeAdAssetLink* assetLink;
@property(nonatomic, nullable) NSArray<RPSNativeAdEventTracker*>* eventTrackers;

/**
 * help method to convert one bid json to one RPSNativeAd
 */
+(instancetype)parse:(NSDictionary *)bidData;

@end



NS_ASSUME_NONNULL_END
