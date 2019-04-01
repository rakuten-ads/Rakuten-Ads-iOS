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
#import <RPSCore/RPSHttpTask.h>
#import "RPSNativeAdsEventTrackRequest.h"

#pragma mark - RPSNativeAdsAsset wtih writable properties
@interface RPSNativeAdsAsset()

@property(nonatomic, getter=isRequired) Boolean required;

-(void) parse:(NSDictionary*) data;

+(instancetype) factoryAsset:(NSDictionary*) assetJson;

@end

@implementation RPSNativeAdsAsset

-(void)parse:(NSDictionary *)data {
    RPSLog(@"unimplement!");
}

+(instancetype) factoryAsset:(NSDictionary *)assetData {
    RPSNativeAdsAsset* asset = nil;
    RPSJSONObject* assetJson = [RPSJSONObject jsonWithRawDictionary:assetData];

    NSDictionary* titleData = [assetJson getJson:@"text"].rawDict;
    if (titleData) {
        asset = [RPSNativeAdsAssetTitle new];
        [asset parse:titleData];
    }

    return asset;
}

@end

#pragma mark - RPSNativeAdsAssetImage wtih writable properties
@interface RPSNativeAdsAssetImage()

@property(nonatomic) NSString* url;
@property(nonatomic) int w;
@property(nonatomic) int h;
@property(nonatomic) RPSNativeAdsAssetImageType type;
@property(nonatomic) NSDictionary* ext;

-(void) parse:(NSDictionary*) imgAssetJson;

@end

@implementation RPSNativeAdsAssetImage

-(void)parse:(NSDictionary *)imgAssetJson {
    RPSJSONObject* imgAsset = [RPSJSONObject jsonWithRawDictionary:imgAssetJson];

    // url
    self.url = [imgAsset getString:@"url"];

    // w / h
    self.w = [[imgAsset getNumber:@"w"] intValue];
    self.h = [[imgAsset getNumber:@"h"] intValue];

    // type
    int type = [[imgAsset getNumber:@"type"] intValue];
    switch (type) {
        case 1:
            self.type = RPSNativeAdsAssetImageTypeIcon;
            break;
        case 3:
            self.type = RPSNativeAdsAssetImageTypeMain;
            break;
        default:
            self.type = RPSNativeAdsAssetImageTypeOther;
            break;
    }

    // ext
    self.ext = [imgAsset getJson:@"ext"].rawDict;
}

@end

#pragma mark - RPSNativeAdsAssetTitle wtih writable properties
@interface RPSNativeAdsAssetTitle()

@property(nonatomic) NSString* text;
@property(nonatomic) int length;
@property(nonatomic) NSDictionary* ext;

-(void) parse:(NSDictionary*) titleAssetJson;

@end

@implementation RPSNativeAdsAssetTitle

-(void)parse:(NSDictionary *)titleAssetJson {
    RPSJSONObject* titleAsset = [RPSJSONObject jsonWithRawDictionary:titleAssetJson];

    // text
    self.text = [titleAsset getString:@"text"];

    // length
    self.length = [[titleAsset getNumber:@"len"] intValue];

    // ext
    self.ext = [titleAsset getJson:@"ext"].rawDict;
}
@end

#pragma mark - RPSNativeAdsAssetData wtih writable properties
@interface RPSNativeAdsAssetData()

@property(nonatomic) NSString* value;
@property(nonatomic) int type;
@property(nonatomic) int len;
@property(nonatomic) NSDictionary* ext;

-(void) parse:(NSDictionary*) dataAssetJson;

@end

@implementation RPSNativeAdsAssetData

-(void)parse:(NSDictionary *)dataAssetJson {
    RPSJSONObject* dataAsset = [RPSJSONObject jsonWithRawDictionary:dataAssetJson];

    // value
    self.value = [dataAsset getString:@"value"];

    // type
    self.type = [[dataAsset getNumber:@"type"] intValue];

    // len
    self.len = [[dataAsset getNumber:@"len"] intValue];

    // ext
    self.ext = [dataAsset getJson:@"ext"].rawDict;
}

@end

#pragma mark - RPSNativeAdsEventTracker wtih writable properties
@interface RPSNativeAdsEventTracker() <RPSHttpTaskDelegate>

@property(nonatomic) int method;
@property(nonatomic) NSString* url;

@end

@implementation RPSNativeAdsEventTracker

- (nonnull NSString *)getUrl {
    return self.url;
}

@end


#pragma mark -
#pragma mark - RPSNativeAds
@interface RPSNativeAds()

@property(nonatomic, nullable) NSString* link;
@property(nonatomic, nullable) NSArray<NSString*>* clickTrackers;
@property(nonatomic, nullable) NSArray<RPSNativeAdsEventTracker*>* eventTrackers;

@end

@implementation RPSNativeAds

+(instancetype)parse:(NSDictionary *)bidData {
    RPSNativeAds* nativeAds = [RPSNativeAds new];

    RPSJSONObject* bidJson = [RPSJSONObject jsonWithRawDictionary:bidData];
    RPSJSONObject* nativeJson = [bidJson getJson:@"ext.admnative"];

    // fallback to adm string
    if (!nativeJson) {
        NSString* adm = [bidJson getString:@"adm"];
        if (adm) {
            NSDictionary* admJson = [NSJSONSerialization JSONObjectWithData:[adm dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            nativeJson = [RPSJSONObject jsonWithRawDictionary:admJson];
        }
    }

    // assets
    NSMutableArray* assetsList = [NSMutableArray array];
    for (NSDictionary* assetData in [nativeJson getArray:@"assets"]) {

        RPSNativeAdsAsset* asset = [RPSNativeAdsAsset factoryAsset:assetData];
        [assetsList addObject:asset];
    }
    if (assetsList.count > 0) {
        nativeAds->_assets = [NSArray arrayWithArray:assetsList];
    }

    // link
    nativeAds.link = [nativeJson getString:@"link.url"];
    nativeAds.clickTrackers = [nativeJson getArray:@"clicktrackers"];

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

            for (RPSNativeAdsEventTracker* clickTracker in self.clickTrackers) {
                RPSNativeAdsEventTrackRequest* request = [RPSNativeAdsEventTrackRequest new];
                request.httpTaskDelegate = clickTracker;
                [request resume];
            }
        }

    }
}

-(void)fireImpression {
    for (RPSNativeAdsEventTracker* impLink in self.eventTrackers) {
        VERBOSE_LOG(@"fire imp %@", impLink);
        RPSNativeAdsEventTrackRequest* request = [RPSNativeAdsEventTrackRequest new];
        request.httpTaskDelegate = impLink;
        [request resume];
    }
}
@end
