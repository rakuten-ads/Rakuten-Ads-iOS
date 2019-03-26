//
//  RPSNativeAdsInner.m
//  RDN
//
//  Created by Wu, Wei b on 2019/03/20.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSNativeAdsInner.h"
#import <RPSCore/RPSJSONObject.h>
#import <RPSCore/RPSValid.h>
#import <UIKit/UIKit.h>
#import "RPSNativeAdsImpRequest.h"

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

        RPSJSONObject* imageJson = [assetJson getJson:@"img"];
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


-(void)fireClick {
    if ([RPSValid isNotEmptyString:self.link]) {
        NSURL* clickUrl = [NSURL URLWithString:self.link];
        if (clickUrl) {
            VERBOSE_LOG(@"fire click %@", clickUrl);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:clickUrl];
            });
        }
    }
}

-(void)fireImps {
    for (NSString* impLink in self.eventTrackers) {
        VERBOSE_LOG(@"fire imp %@", impLink);
        RPSNativeAdsImpRequest* impRequest = [RPSNativeAdsImpRequest new];
        impRequest.impLink = impLink;
        [impRequest resume];
    }
}
@end
