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
#import <RPSCore/RPSJSONObject.h>

#pragma mark - NSString extension
@interface NSString (RPSSDK) <RPSHttpTaskDelegate>

@end

@implementation NSString (RPSSDK)

-(NSString*) getUrl {
    return self;
}

@end

#pragma mark - Asset Types

// super
@implementation RPSNativeAdAsset

int RPSNativeAdAssetRequiredYes = 1;
-(void)parse:(RPSJSONObject*) assetJson {
    self->_required = [assetJson getNumber:@"required"].intValue == RPSNativeAdAssetRequiredYes;
}

+(instancetype) factoryAsset:(NSDictionary *)assetData {
    RPSNativeAdAsset* asset = nil;
    RPSJSONObject* assetJson = [RPSJSONObject jsonWithRawDictionary:assetData];

    if ([assetJson getJson:@"title"]) {
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
    self->_url = [assetJson getString:@"img.url"];

    // w / h
    self->_w = [[assetJson getNumber:@"img.w"] intValue];
    self->_h = [[assetJson getNumber:@"img.h"] intValue];

    // type
    int type = [[assetJson getNumber:@"img.type"] intValue];
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

-(NSString *)description {
    return [NSString stringWithFormat:@"[Asset Image] %@: %@",
            self.type == RPSNativeAdAssetImageTypeIcon ? @"Icon" :
            self.type == RPSNativeAdAssetImageTypeMain ? @"Main" :
            @"unkown",
            self.url,
            nil];
}

@end

// title
@implementation RPSNativeAdAssetTitle

-(void)parse:(RPSJSONObject *)assetJson {
    [super parse:assetJson];

    // text
    self->_text = [assetJson getString:@"title.text"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Asset Title: %@", self.text];
}

@end

// data
@implementation RPSNativeAdAssetData

-(void)parse:(RPSJSONObject *)assetJson {
    [super parse:assetJson];

    // value
    self->_value = [assetJson getString:@"data.value"];

    // type
    self->_type = [[assetJson getNumber:@"data.type"] intValue];

    // len
    self->_len = [[assetJson getNumber:@"data.len"] intValue];

    // ext
    self->_ext = [[assetJson getJson:@"data.ext"] rawDict];
}

- (NSString *)description
{
    NSString* type = nil;
    switch (self.type) {
        case RPSNativeAdAssetDataTypeDesc: type = @"desc"; break;
        case RPSNativeAdAssetDataTypePrice: type = @"price"; break;
        case RPSNativeAdAssetDataTypeSaleprice: type = @"saleprice"; break;
        case RPSNativeAdAssetDataTypeSponsored: type = @"sponsored"; break;
        case RPSNativeAdAssetDataTypeCtatext: type = @"ctatext"; break;
        case RPSNativeAdAssetDataTypeRating: type = @"rating"; break;
        default: type = @"specific"; break;
    }
    return [NSString stringWithFormat:@"[Asset Data] %@: %@", type, self.value];
}

@end

#pragma mark - Link Type
@implementation RPSNativeAdAssetLink

-(void)parse:(RPSJSONObject *)assetJson {
    [super parse:assetJson];
    self->_url = [assetJson getString:@"url"];
    self->_fallback = [assetJson getString:@"fallback"];
    self->_clicktrackers = [assetJson getArray:@"clicktrackers"];
}

- (nonnull NSString *)getUrl {
    return self.url;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[Asset Link] URL: %@", self.url];
}

@end


#pragma mark - Event Tracker Type
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


- (NSString *)description
{
    return [NSString stringWithFormat:@"[Native Ad Event Tracker] method=%d: %@", self.method, self.url];
}
@end


#pragma mark -
#pragma mark - RPSNativeAd
@implementation RPSNativeAd

#pragma mark Private APIs

+(instancetype)parse:(NSDictionary *)bidData {

    RPSJSONObject* bidJson = [RPSJSONObject jsonWithRawDictionary:bidData];
    RPSJSONObject* admJson = [bidJson getJson:@"ext.admnative"];

    // fallback to adm string
    if (!admJson) {
        NSString* admString = [bidJson getString:@"adm"];
        if (admString) {
            RPSDebug("use adm string");
            NSError* err;
            NSDictionary* admDict = [NSJSONSerialization JSONObjectWithData:[admString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err];
            if (err) {
                RPSLog("adm string parse error for: %@", admString);
            } else {
                admJson = [RPSJSONObject jsonWithRawDictionary:admDict];
            }
        }
    }

    if (!admJson) {
        RPSDebug("adm not found");
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
            [nativeAds setImage:(RPSNativeAdAssetImage*)asset];
        } else if ([asset isKindOfClass:RPSNativeAdAssetData.class]) {
            [nativeAds setData:(RPSNativeAdAssetData*)asset];
        } else if ([asset isKindOfClass:RPSNativeAdAssetLink.class]) {
            nativeAds->_assetLink = (RPSNativeAdAssetLink*)asset;
        }
    }

    // link
    RPSNativeAdAssetLink* link = [RPSNativeAdAssetLink new];
    [link parse:[admJson getJson:@"link"]];
    if (link.url) {
        nativeAds->_assetLink = link;
    }

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

    RPSDebug("parsed to native ads:\n%@", nativeAds);
    return nativeAds;
}

-(void) setImage:(RPSNativeAdAssetImage*) img {
    if (!self->_assetImgs) {
        self->_assetImgs = [NSMutableArray array];
    }
    [(NSMutableArray<RPSNativeAdAssetImage*>*)self->_assetImgs addObject:img];

    switch (img.type) {
        case RPSNativeAdAssetImageTypeIcon:
            self->_iconImg = img;
            break;
        case RPSNativeAdAssetImageTypeMain:
            self->_mainImg = img;
            break;
        default:
            break;
    }
}

-(void) setData:(RPSNativeAdAssetData*) data {
    if (!self->_assetDatas) {
        self->_assetDatas = [NSMutableArray array];
    }
    [(NSMutableArray<RPSNativeAdAssetData*>*)self->_assetDatas addObject:data];

    switch (data.type) {
        case RPSNativeAdAssetDataTypeDesc:
            self->_desc = data.value;
            break;
        case RPSNativeAdAssetDataTypePrice:
            self->_price = data.value;
            break;
        case RPSNativeAdAssetDataTypeSaleprice:
            self->_salePrice = data.value;
            break;
        case RPSNativeAdAssetDataTypeSponsored:
            self->_sponsor = data.value;
            break;
        case RPSNativeAdAssetDataTypeCtatext:
            self->_ctatext = data.value;
            break;
        case RPSNativeAdAssetDataTypeRating:;
            double r = [data.value doubleValue];
            if (r > 0) {
                self->_rating = [NSNumber numberWithDouble:r];
            }
            break;
        default:
            break;
    }
}

-(NSString *)description {
    return [NSString stringWithFormat:
            @"{ \n"
            @"asset title: %@\n"
            @"asset imgs: %@\n"
            @"asset link: %@\n"
            @"asset datas: %@\n"
            @"asset video: %@\n"
            @" }",
            self.assetTitle,
            [self.assetImgs componentsJoinedByString:@","],
            self.assetLink,
            [self.assetDatas componentsJoinedByString:@","],
            self.assetVideo,
            nil];
}

#pragma mark Public APIs

-(NSString *)title {
    return self.assetTitle.text;
}

-(NSArray<RPSNativeAdAssetData *> *)specificData {
    return [[self.assetDatas filteredArrayUsingPredicate:
             [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject isKindOfClass:[RPSNativeAdAssetData class]]) {
            return ((RPSNativeAdAssetData*)evaluatedObject).type >= 500;
        }
        return NO;
    }]] copy];
}

-(void)fireClick {
    if ([RPSValid isNotEmptyString:self.assetLink.url]) {
        NSURL* clickUrl = [NSURL URLWithString:self.assetLink.url];
        if (clickUrl) {
            RPSLog("fire click %@", clickUrl);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:clickUrl options:@{} completionHandler:nil];
            });

            for (NSString* clickTracker in self.assetLink.clicktrackers) {
                RPSNativeAdEventTrackRequest* request = [RPSNativeAdEventTrackRequest new];
                request.httpTaskDelegate = clickTracker;
                [request resume];
            }
        }

    }
}

-(void)fireImpression {
    for (RPSNativeAdEventTracker* impLink in self.eventTrackers) {
        RPSLog("fire imp %@", impLink);
        RPSNativeAdEventTrackRequest* request = [RPSNativeAdEventTrackRequest new];
        request.httpTaskDelegate = impLink;
        [request resume];
    }
}

@end

