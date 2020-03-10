//
//  RUNANativeAdInner.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/03/20.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNANativeAdInner.h"
#import <RUNACore/RUNAValid.h>
#import <UIKit/UIKit.h>
#import <RUNACore/RUNAHttpTask.h>
#import <RUNACore/RUNAJSONObject.h>
#import "RUNAURLString.h"

#pragma mark - Asset Types

// super
@implementation RUNANativeAdAsset

int RUNANativeAdAssetRequiredYes = 1;
-(void)parse:(RUNAJSONObject*) assetJson {
    self->_required = [assetJson getNumber:@"required"].intValue == RUNANativeAdAssetRequiredYes;
}

+(instancetype) factoryAsset:(NSDictionary *)assetData {
    RUNANativeAdAsset* asset = nil;
    RUNAJSONObject* assetJson = [RUNAJSONObject jsonWithRawDictionary:assetData];

    if ([assetJson getJson:@"title"]) {
        asset = [RUNANativeAdAssetTitle new];
    } else if ([assetJson getJson:@"img"]) {
        asset = [RUNANativeAdAssetImage new];
    } else if ([assetJson getJson:@"data"]) {
        asset = [RUNANativeAdAssetData new];
    }

    [asset parse:assetJson];
    return asset;
}

@end

// image
@implementation RUNANativeAdAssetImage

-(void)parse:(RUNAJSONObject *)assetJson {
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
            self->_type = RUNANativeAdAssetImageTypeIcon;
            break;
        case 3:
            self->_type = RUNANativeAdAssetImageTypeMain;
            break;
        default:
            self->_type = RUNANativeAdAssetImageTypeOther;
            break;
    }
}

-(NSString *)description {
    return [NSString stringWithFormat:@"[Asset Image] %@: %@",
            self.type == RUNANativeAdAssetImageTypeIcon ? @"Icon" :
            self.type == RUNANativeAdAssetImageTypeMain ? @"Main" :
            @"unkown",
            self.url,
            nil];
}

@end

// title
@implementation RUNANativeAdAssetTitle

-(void)parse:(RUNAJSONObject *)assetJson {
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
@implementation RUNANativeAdAssetData

-(void)parse:(RUNAJSONObject *)assetJson {
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
        case RUNANativeAdAssetDataTypeDesc: type = @"desc"; break;
        case RUNANativeAdAssetDataTypePrice: type = @"price"; break;
        case RUNANativeAdAssetDataTypeSaleprice: type = @"saleprice"; break;
        case RUNANativeAdAssetDataTypeSponsored: type = @"sponsored"; break;
        case RUNANativeAdAssetDataTypeCtatext: type = @"ctatext"; break;
        case RUNANativeAdAssetDataTypeRating: type = @"rating"; break;
        default: type = @"specific"; break;
    }
    return [NSString stringWithFormat:@"[Asset Data] %@: %@", type, self.value];
}

@end

#pragma mark - Link Type
@implementation RUNANativeAdAssetLink

-(void)parse:(RUNAJSONObject *)assetJson {
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
@implementation RUNANativeAdEventTracker

- (nonnull NSString *)getUrl {
    return self.url;
}

-(void)parse:(RUNAJSONObject *)assetJson {
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
#pragma mark - RUNANativeAd
@implementation RUNANativeAd

#pragma mark Private APIs

+(instancetype)parse:(NSDictionary *)bidData {

    RUNAJSONObject* bidJson = [RUNAJSONObject jsonWithRawDictionary:bidData];
    RUNAJSONObject* admJson = [bidJson getJson:@"ext.admnative"];

    // fallback to adm string
    if (!admJson) {
        NSString* admString = [bidJson getString:@"adm"];
        if (admString) {
            RUNADebug("use adm string");
            NSError* err;
            NSDictionary* admDict = [NSJSONSerialization JSONObjectWithData:[admString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err];
            if (err) {
                RUNALog("adm string parse error for: %@", admString);
            } else {
                admJson = [RUNAJSONObject jsonWithRawDictionary:admDict];
            }
        }
    }

    if (!admJson) {
        RUNADebug("adm not found");
        return nil;
    }

    RUNANativeAd* nativeAds = [RUNANativeAd new];
    nativeAds->_rawData = bidData;

    // assets
    for (NSDictionary* assetData in [admJson getArray:@"assets"]) {
        RUNANativeAdAsset* asset = [RUNANativeAdAsset factoryAsset:assetData];

        if ([asset isKindOfClass:RUNANativeAdAssetTitle.class]) {
            nativeAds->_assetTitle = (RUNANativeAdAssetTitle*)asset;
        } else if ([asset isKindOfClass:RUNANativeAdAssetImage.class]) {
            [nativeAds setImage:(RUNANativeAdAssetImage*)asset];
        } else if ([asset isKindOfClass:RUNANativeAdAssetData.class]) {
            [nativeAds setData:(RUNANativeAdAssetData*)asset];
        } else if ([asset isKindOfClass:RUNANativeAdAssetLink.class]) {
            nativeAds->_assetLink = (RUNANativeAdAssetLink*)asset;
        }
    }

    // link
    RUNANativeAdAssetLink* link = [RUNANativeAdAssetLink new];
    [link parse:[admJson getJson:@"link"]];
    if (link.url) {
        nativeAds->_assetLink = link;
    }

    // eventTrackers
    NSMutableArray<RUNANativeAdEventTracker*>* eventTrackerList = [NSMutableArray array];
    for (NSDictionary* eventTrackerData in [admJson getArray:@"eventtrackers"]) {
        RUNAJSONObject* eventTrackerJson = [RUNAJSONObject jsonWithRawDictionary:eventTrackerData];
        RUNANativeAdEventTracker* tracker = [RUNANativeAdEventTracker new];
        [tracker parse:eventTrackerJson];
        [eventTrackerList addObject:tracker];
    }
    if (eventTrackerList.count > 0) {
        nativeAds->_eventTrackers = [NSArray arrayWithArray:eventTrackerList];
    }

    // privacy page URL
    nativeAds->_privacyURL = [admJson getString:@"privacy"];

    RUNADebug("parsed to native ads:\n%@", nativeAds);
    return nativeAds;
}

-(void) setImage:(RUNANativeAdAssetImage*) img {
    if (!self->_assetImgs) {
        self->_assetImgs = [NSMutableArray array];
    }
    [(NSMutableArray<RUNANativeAdAssetImage*>*)self->_assetImgs addObject:img];

    switch (img.type) {
        case RUNANativeAdAssetImageTypeIcon:
            self->_iconImg = img;
            break;
        case RUNANativeAdAssetImageTypeMain:
            self->_mainImg = img;
            break;
        default:
            break;
    }
}

-(void) setData:(RUNANativeAdAssetData*) data {
    if (!self->_assetDatas) {
        self->_assetDatas = [NSMutableArray array];
    }
    [(NSMutableArray<RUNANativeAdAssetData*>*)self->_assetDatas addObject:data];

    switch (data.type) {
        case RUNANativeAdAssetDataTypeDesc:
            self->_desc = data.value;
            break;
        case RUNANativeAdAssetDataTypePrice:
            self->_price = data.value;
            break;
        case RUNANativeAdAssetDataTypeSaleprice:
            self->_salePrice = data.value;
            break;
        case RUNANativeAdAssetDataTypeSponsored:
            self->_sponsor = data.value;
            break;
        case RUNANativeAdAssetDataTypeCtatext:
            self->_ctatext = data.value;
            break;
        case RUNANativeAdAssetDataTypeRating:;
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

-(NSArray<RUNANativeAdAssetData *> *)specificData {
    return [[self.assetDatas filteredArrayUsingPredicate:
             [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject isKindOfClass:[RUNANativeAdAssetData class]]) {
            return ((RUNANativeAdAssetData*)evaluatedObject).type >= 500;
        }
        return NO;
    }]] copy];
}

-(void)fireClick {
    if ([RUNAValid isNotEmptyString:self.assetLink.url]) {
        NSURL* clickUrl = [NSURL URLWithString:self.assetLink.url];
        if (clickUrl) {
            RUNALog("fire click %@", clickUrl);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:clickUrl options:@{} completionHandler:nil];
            });

            for (NSString* clickTracker in self.assetLink.clicktrackers) {
                RUNAURLStringRequest* request = [RUNAURLStringRequest new];
                request.httpTaskDelegate = clickTracker;
                [request resume];
            }
        }

    }
}

-(void)fireImpression {
    for (RUNANativeAdEventTracker* impLink in self.eventTrackers) {
        RUNALog("fire imp %@", impLink);
        RUNAURLStringRequest* request = [RUNAURLStringRequest new];
        request.httpTaskDelegate = impLink;
        [request resume];
    }
}

@end

