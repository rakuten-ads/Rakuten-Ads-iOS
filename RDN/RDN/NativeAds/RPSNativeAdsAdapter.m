//
//  RPSNativeAdsAdapter.m
//  RDN
//
//  Created by Wu, Wei b on 2019/03/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSNativeAdsAdapter.h"
#import <RPSCore/RPSJSONObject.h>

#pragma mark - RPSNativeAdsAssetImage wtih writable properties
@interface RPSNativeAdsAssetImage()

@property(nonatomic) NSString* url;
@property(nonatomic) int w;
@property(nonatomic) int h;

@end

@implementation RPSNativeAdsAssetImage

@end

#pragma mark - RPSNativeAdsAsset wtih writable properties
@interface RPSNativeAdsAsset()

@property(nonatomic, getter=isRequired) Boolean required;
@property(nonatomic, nullable) NSString* title;
@property(nonatomic, nullable) RPSNativeAdsAssetImage* img;
@property(nonatomic, nullable) NSString* data;

@end

@implementation RPSNativeAdsAsset

@end

#pragma mark - RPSNativeAdsEventTracker wtih writable properties
@interface RPSNativeAdsEventTracker()

@property(nonatomic) int method;
@property(nonatomic) NSString* url;

@end

@implementation RPSNativeAdsEventTracker

@end


#pragma mark - RPSNativeAds
@interface RPSNativeAds()<RPSAdInfo>

@end

@implementation RPSNativeAds

+(instancetype)parse:(NSDictionary *)bidData {
    RPSNativeAds* nativeAds = [RPSNativeAds new];

    RPSJSONObject* bidJson = [RPSJSONObject jsonWithRawDictionary:bidData];
    RPSJSONObject* nativeJson = [bidJson getJson:@"ext.admnative"];

    // assets
    NSMutableArray* assetsList = [NSMutableArray array];
    for (NSDictionary* assetData in [nativeJson getArray:@"assets"]) {
        RPSJSONObject* assetJson = [RPSJSONObject jsonWithRawDictionary:assetData];
        RPSNativeAdsAsset* asset = [RPSNativeAdsAsset new];

        asset.title = [assetJson getString:@"title.text"];

        RPSJSONObject* imageJson = [assetJson getJson:@"image"];
        if (imageJson) {
            RPSNativeAdsAssetImage* assetImage = [RPSNativeAdsAssetImage new];
            assetImage.url = [imageJson getString:@"url"];
            assetImage.w = [[imageJson getNumber:@"w"] intValue];
            assetImage.h = [[imageJson getNumber:@"h"] intValue];
            asset.img = assetImage;
        }

        asset.data = [assetJson getString:@"data.value"];
        [assetsList addObject:asset];
    };
    if (assetsList.count > 0) {
        nativeAds->_assets = [NSArray arrayWithArray:assetsList];
    }

    // link
    nativeAds->_link = [nativeJson getString:@"link.url"];

    // eventTrackers
    NSMutableArray* eventTrackerList = [NSMutableArray array];
    for (NSDictionary* eventTrackerData in [nativeJson getArray:@"eventtrackers"]) {
        RPSJSONObject* eventTrackerJson = [RPSJSONObject jsonWithRawDictionary:eventTrackerData];
        NSString* eventTrackerLink = [eventTrackerJson getString:@"url"];
        // TODO method

        [eventTrackerList addObject:eventTrackerLink];
    }
    if (eventTrackerList.count > 0) {
        nativeAds->_eventTrackers = [NSArray arrayWithArray:eventTrackerList];
    }

    return nativeAds;
}

@end


@implementation RPSNativeAdsAdapter
@synthesize adspotIdList = _adspotIdList;

-(NSArray<NSString *> *)adspotIdList {
    if (self.adspotId) {
        return @[self.adspotId];
    }
    return nil;
}


@end
