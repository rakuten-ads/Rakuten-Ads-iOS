//
//  RPSNativeAdInner.m
//  RDN
//
//  Created by Wu, Wei b on 2019/03/20.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSNativeAdInner.h"
#import <RPSCore/RPSValid.h>
#import <UIKit/UIKit.h>
#import <RPSCore/RPSHttpTask.h>
#import "RPSNativeAdEventTrackRequest.h"

#pragma mark - Asset Objects
// super
@implementation RPSNativeAdAsset

-(void)parse:(RPSJSONObject*) assetJson {
    self->_required = [assetJson getNumber:@"required"].intValue == 1;
}

+(instancetype) factoryAsset:(NSDictionary *)assetData {
    RPSNativeAdAsset* asset = nil;
    RPSJSONObject* assetJson = [RPSJSONObject jsonWithRawDictionary:assetData];

    if ([assetJson getJson:@"text"]) {
        asset = [RPSNativeAdAssetTitle new];
    } else if ([assetJson getJson:@"img"]) {
        asset = [RPSNativeAdAssetImage new];
    } else if ([assetJson getJson:@"data"]) {
        asset = [RPSNativeAdAssetData new];
    }

    [asset parse:assetJson];
    return asset;
}

@end

// image
@implementation RPSNativeAdAssetImage

-(void)parse:(RPSJSONObject *)assetJson {
    [super parse:assetJson];

    // url
    self->_url = [assetJson getString:@"url"];

    // w / h
    self->_w = [[assetJson getNumber:@"w"] intValue];
    self->_h = [[assetJson getNumber:@"h"] intValue];

    // type
    int type = [[assetJson getNumber:@"type"] intValue];
    switch (type) {
        case 1:
            self->_type = RPSNativeAdAssetImageTypeIcon;
            break;
        case 3:
            self->_type = RPSNativeAdAssetImageTypeMain;
            break;
        default:
            self->_type = RPSNativeAdAssetImageTypeOther;
            break;
    }
}

@end

// title
@implementation RPSNativeAdAssetTitle

-(void)parse:(RPSJSONObject *)assetJson {
    [super parse:assetJson];

    // text
    self->_text = [assetJson getString:@"text"];
}

@end

// data
@implementation RPSNativeAdAssetData

-(void)parse:(RPSJSONObject *)assetJson {
    [super parse:assetJson];

    // value
    self->_value = [assetJson getString:@"value"];

    // type
    self->_type = [[assetJson getNumber:@"type"] intValue];

    // len
    self->_len = [[assetJson getNumber:@"len"] intValue];
}

@end

#pragma mark - Link Object
@implementation RPSNativeAdAssetLink

- (nonnull NSString *)getUrl {
    return self.url;
}

@end


#pragma mark - Event Tracker Object
@implementation RPSNativeAdEventTracker

- (nonnull NSString *)getUrl {
    return self.url;
}

-(void)parse:(RPSJSONObject *)assetJson {
    // url
    self->_url = [assetJson getString:@"url"];

    // event
    self->_event = [[assetJson getNumber:@"event"] intValue];

    // method
    self->_method = [[assetJson getNumber:@"method"] intValue];
}

@end




#pragma mark -
#pragma mark - RPSNativeAd
@implementation RPSNativeAd

+(instancetype)parse:(NSDictionary *)bidData {

    RPSJSONObject* bidJson = [RPSJSONObject jsonWithRawDictionary:bidData];
    RPSJSONObject* admJson = [bidJson getJson:@"ext.admnative"];

    // fallback to adm string
    if (!admJson) {
        NSString* admString = [bidJson getString:@"adm"];
        if (admString) {
            RPSLog(@"use adm string");
            NSError* err;
            NSDictionary* admDict = [NSJSONSerialization JSONObjectWithData:[admString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err];
            if (err) {
                VERBOSE_WARN(@"adm string parse error for: %@", admString);
            } else {
                admJson = [RPSJSONObject jsonWithRawDictionary:admDict];
            }
        }
    }

    if (!admJson) {
        RPSLog(@"adm not found");
        return nil;
    }

    RPSNativeAd* nativeAds = [RPSNativeAd new];
    nativeAds->_rawData = bidData;

    // assets
    for (NSDictionary* assetData in [admJson getArray:@"assets"]) {
        RPSNativeAdAsset* asset = [RPSNativeAdAsset factoryAsset:assetData];

        if ([asset isKindOfClass:RPSNativeAdAssetTitle.class]) {
            nativeAds->_assetTitle = (RPSNativeAdAssetTitle*)asset;

        } else if ([asset isKindOfClass:RPSNativeAdAssetImage.class]) {
            if (!nativeAds->_assetImgs) {
                nativeAds->_assetImgs = [NSMutableArray array];
            }
            [(NSMutableArray<RPSNativeAdAssetImage*>*)nativeAds->_assetImgs addObject:(RPSNativeAdAssetImage*)asset];

        } else if ([asset isKindOfClass:RPSNativeAdAssetData.class]) {
            nativeAds->_assetData = (RPSNativeAdAssetData*)asset;

        } else if ([asset isKindOfClass:RPSNativeAdAssetLink.class]) {
            nativeAds->_assetLink = (RPSNativeAdAssetLink*)asset;
        }
    }

    // link
    RPSNativeAdAssetLink* link = [RPSNativeAdAssetLink new];
    [link parse:[admJson getJson:@"link"]];
    nativeAds->_assetLink = link;

    // eventTrackers
    NSMutableArray<RPSNativeAdEventTracker*>* eventTrackerList = [NSMutableArray array];
    for (NSDictionary* eventTrackerData in [admJson getArray:@"eventtrackers"]) {
        RPSJSONObject* eventTrackerJson = [RPSJSONObject jsonWithRawDictionary:eventTrackerData];
        RPSNativeAdEventTracker* tracker = [RPSNativeAdEventTracker new];
        [tracker parse:eventTrackerJson];
        [eventTrackerList addObject:tracker];
    }
    if (eventTrackerList.count > 0) {
        nativeAds->_eventTrackers = [NSArray arrayWithArray:eventTrackerList];
    }

    // privacy page URL
    nativeAds->_privacyURL = [admJson getString:@"privacy"];

    return nativeAds;
}


-(void)fireClick {
    if ([RPSValid isNotEmptyString:self.assetLink.url]) {
        NSURL* clickUrl = [NSURL URLWithString:self.assetLink.url];
        if (clickUrl) {
            VERBOSE_LOG(@"fire click %@", clickUrl);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:clickUrl];
            });

//            for (RPSNativeAdEventTracker* clickTracker in self.clickTrackers) {
//                RPSNativeAdEventTrackRequest* request = [RPSNativeAdEventTrackRequest new];
//                request.httpTaskDelegate = clickTracker;
//                [request resume];
//            }
        }

    }
}

-(void)fireImpression {
    for (RPSNativeAdEventTracker* impLink in self.eventTrackers) {
        VERBOSE_LOG(@"fire imp %@", impLink);
        RPSNativeAdEventTrackRequest* request = [RPSNativeAdEventTrackRequest new];
        request.httpTaskDelegate = impLink;
        [request resume];
    }
}
@end
