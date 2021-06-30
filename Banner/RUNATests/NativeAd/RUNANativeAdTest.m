//
//  RUNANativeAdTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/24.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNANativeAd.h"
#import "RUNANativeAdInner.h"
#import "RUNATests+Extension.h"

@interface RUNANativeAd (Spy)
- (void)setImage:(RUNANativeAdAssetImage *)img;
- (void)setData:(RUNANativeAdAssetData *)data;
@end

@interface RUNANativeAdTest : XCTestCase
@end

@implementation RUNANativeAdTest

#pragma mark - RUNANativeAd

- (void)testParse {
    {
        // Case: Objects parse
        NSDictionary *link = @{@"url":@"url", @"fallback":@"fallback", @"clicktrackers":@[@"hoge"]}; // Mock link
        NSArray *eventtrackers = @[@{@"url":@"event_url", @"event":@1, @"method":@2}]; // Mock eventtrackers
        NSArray *assets = @[@{@"title":@{}}, @{@"img":@{}}, @{@"data":@{}}]; // Mock assets
        RUNANativeAd *ad = [RUNANativeAd parse:@{@"ext.admnative":@{@"adm":@"</div>",
                                                                    @"link":link,
                                                                    @"eventtrackers":eventtrackers,
                                                                    @"assets":assets,
                                                                    @"privacy":@"privacy_url"}}];
        XCTAssertNotNil(ad);
        XCTAssertNotNil(ad.rawData);
        XCTAssertNotNil(ad.assetTitle);
        XCTAssertNotNil(ad.assetImgs);
        XCTAssertNotNil(ad.assetDatas);
        XCTAssertNotNil(ad.assetLink);
        XCTAssertNotNil(ad.eventTrackers);
        XCTAssertEqualObjects(ad.privacyURL, @"privacy_url");
    }
    {
        // Case: admJson is nil
        XCTAssertNil([RUNANativeAd parse:@{@"key":@"value"}]);
        XCTAssertNil([RUNANativeAd parse:@{@"adm":@"value"}]);
    }
    {
        // Case: admJson from json string
        NSString *jsonString = @"{\"dummy\":{\"id\":1,\"type\":\"type\"}}";
        XCTAssertNotNil([RUNANativeAd parse:@{@"adm":jsonString}]);
    }
}

- (void)testSetImage {
    {
        RUNANativeAd *ad = [RUNANativeAd new];
        RUNANativeAdAssetImage *asset = [RUNANativeAdAssetImage new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{@"img.type": @(RUNANativeAdAssetImageTypeIcon)}]];
        [ad setImage:asset];
        XCTAssertEqual(ad.assetImgs.count, (NSUInteger)1);
        XCTAssertNotNil(ad.iconImg);
        XCTAssertNil(ad.mainImg);
    }
    {
        RUNANativeAd *ad = [RUNANativeAd new];
        RUNANativeAdAssetImage *asset = [RUNANativeAdAssetImage new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{@"img.type": @(RUNANativeAdAssetImageTypeMain)}]];
        [ad setImage:asset];
        XCTAssertEqual(ad.assetImgs.count, (NSUInteger)1);
        XCTAssertNil(ad.iconImg);
        XCTAssertNotNil(ad.mainImg);
    }
    {
        RUNANativeAd *ad = [RUNANativeAd new];
        RUNANativeAdAssetImage *asset = [RUNANativeAdAssetImage new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{@"img.type": @(RUNANativeAdAssetImageTypeOther)}]];
        [ad setImage:asset];
        XCTAssertEqual(ad.assetImgs.count, (NSUInteger)1);
        XCTAssertNil(ad.iconImg);
        XCTAssertNil(ad.mainImg);
    }
}

- (void)testSetData {
    {
        RUNANativeAd *ad = [RUNANativeAd new];
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{@"data.type":@(RUNANativeAdAssetDataTypeSponsored), @"data.value":@"value"}]];
        [ad setData:asset];
        XCTAssertEqual(ad.assetDatas.count, (NSUInteger)1);
        XCTAssertEqualObjects(ad.sponsor, @"value");
        XCTAssertNil(ad.desc);
        XCTAssertNil(ad.price);
        XCTAssertNil(ad.salePrice);
        XCTAssertNil(ad.ctatext);
        XCTAssertNil(ad.rating);
    }
    {
        RUNANativeAd *ad = [RUNANativeAd new];
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{@"data.type":@(RUNANativeAdAssetDataTypeDesc), @"data.value":@"value"}]];
        [ad setData:asset];
        XCTAssertEqual(ad.assetDatas.count, (NSUInteger)1);
        XCTAssertNil(ad.sponsor);
        XCTAssertEqualObjects(ad.desc, @"value");
        XCTAssertNil(ad.price);
        XCTAssertNil(ad.salePrice);
        XCTAssertNil(ad.ctatext);
        XCTAssertNil(ad.rating);
    }
    {
        RUNANativeAd *ad = [RUNANativeAd new];
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{@"data.type":@(RUNANativeAdAssetDataTypeRating), @"data.value":@"1"}]];
        [ad setData:asset];
        XCTAssertEqual(ad.assetDatas.count, (NSUInteger)1);
        XCTAssertNil(ad.sponsor);
        XCTAssertNil(ad.desc);
        XCTAssertNil(ad.price);
        XCTAssertNil(ad.salePrice);
        XCTAssertNil(ad.ctatext);
        XCTAssertEqual(ad.rating, [NSNumber numberWithDouble:[@"1" doubleValue]]);
    }
    {
        RUNANativeAd *ad = [RUNANativeAd new];
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{@"data.type":@(RUNANativeAdAssetDataTypeRating), @"data.value":@"-1"}]];
        [ad setData:asset];
        XCTAssertNil(ad.rating);
    }
    {
        RUNANativeAd *ad = [RUNANativeAd new];
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{@"data.type":@(RUNANativeAdAssetDataTypePrice), @"data.value":@"value"}]];
        [ad setData:asset];
        XCTAssertEqual(ad.assetDatas.count, (NSUInteger)1);
        XCTAssertNil(ad.sponsor);
        XCTAssertNil(ad.desc);
        XCTAssertEqualObjects(ad.price, @"value");
        XCTAssertNil(ad.salePrice);
        XCTAssertNil(ad.ctatext);
        XCTAssertNil(ad.rating);
    }
    {
        RUNANativeAd *ad = [RUNANativeAd new];
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{@"data.type":@(RUNANativeAdAssetDataTypeSaleprice), @"data.value":@"value"}]];
        [ad setData:asset];
        XCTAssertEqual(ad.assetDatas.count, (NSUInteger)1);
        XCTAssertNil(ad.sponsor);
        XCTAssertNil(ad.desc);
        XCTAssertNil(ad.price);
        XCTAssertEqualObjects(ad.salePrice, @"value");
        XCTAssertNil(ad.ctatext);
        XCTAssertNil(ad.rating);
    }
    {
        RUNANativeAd *ad = [RUNANativeAd new];
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{@"data.type":@(RUNANativeAdAssetDataTypeCtatext), @"data.value":@"value"}]];
        [ad setData:asset];
        XCTAssertEqual(ad.assetDatas.count, (NSUInteger)1);
        XCTAssertNil(ad.sponsor);
        XCTAssertNil(ad.desc);
        XCTAssertNil(ad.price);
        XCTAssertNil(ad.salePrice);
        XCTAssertEqualObjects(ad.ctatext, @"value");
        XCTAssertNil(ad.rating);
    }
    {
        RUNANativeAd *ad = [RUNANativeAd new];
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{@"data.type":@(RUNANativeAdAssetDataTypeOther), @"data.value":@"value"}]];
        [ad setData:asset];
        XCTAssertEqual(ad.assetDatas.count, (NSUInteger)1);
        XCTAssertNil(ad.sponsor);
        XCTAssertNil(ad.desc);
        XCTAssertNil(ad.price);
        XCTAssertNil(ad.salePrice);
        XCTAssertNil(ad.ctatext);
        XCTAssertNil(ad.rating);
    }
}

- (void)testDescription {
    RUNANativeAd *ad = [RUNANativeAd new];
    
    RUNANativeAdAssetTitle *title = [RUNANativeAdAssetTitle new];
    [title parse:[RUNAJSONObject jsonWithRawDictionary:@{@"title.text":@"title"}]];
    ad.assetTitle = title;
    
    RUNANativeAdAssetImage *image = [RUNANativeAdAssetImage new];
    [image parse:[RUNAJSONObject jsonWithRawDictionary:@{@"img.url":@"image_url", @"img.type": @(RUNANativeAdAssetImageTypeIcon)}]];
    ad.assetImgs = @[image];
    
    RUNANativeAdAssetLink *link = [RUNANativeAdAssetLink new];
    [link parse:[RUNAJSONObject jsonWithRawDictionary:@{@"url":@"link_url"}]];
    ad.assetLink = link;
    
    RUNANativeAdAssetData *data = [RUNANativeAdAssetData new];
    [data parse:[RUNAJSONObject jsonWithRawDictionary:@{@"data.value":@"value", @"data.type":@(RUNANativeAdAssetDataTypeSponsored)}]];
    ad.assetDatas = @[data];
    
    // NOTE: assetVideo is not supported for native ads.
    NSString *description = [NSString stringWithFormat:@"%@", ad];
    XCTAssertEqualObjects(description, @"{ \n"
                          @"asset title: Asset Title: title\n"
                          @"asset imgs: [Asset Image] Icon: image_url\n"
                          @"asset link: [Asset Link] URL: link_url\n"
                          @"asset datas: [Asset Data] sponsored: value\n"
                          //@"asset video: (null)\n"
                          @" }");
}

#pragma mark - Public API

- (void)testGetTitle {
    RUNANativeAd *ad = [RUNANativeAd new];
    RUNANativeAdAssetTitle *title = [RUNANativeAdAssetTitle new];
    [title parse:[RUNAJSONObject jsonWithRawDictionary:@{@"title.text":@"title"}]];
    ad.assetTitle = title;
    XCTAssertEqualObjects([ad title], @"title");
}

- (void)testSpecificData {
    RUNANativeAd *ad = [RUNANativeAd new];
    RUNANativeAdAssetData *data1 = [RUNANativeAdAssetData new];
    [data1 parse:[RUNAJSONObject jsonWithRawDictionary:@{@"data.type":@(RUNANativeAdAssetDataTypeSponsored)}]];
    RUNANativeAdAssetData *data2 = [RUNANativeAdAssetData new];
    [data2 parse:[RUNAJSONObject jsonWithRawDictionary:@{@"data.type":@(RUNANativeAdAssetDataTypeOther), @"data.value":@"value"}]];
    RUNANativeAdAssetTitle *data3 = [RUNANativeAdAssetTitle new]; // defferent type
    ad.assetDatas = @[data1, data2, data3];
    NSArray<RUNANativeAdAssetData*> *actuals = [ad specificData];
    XCTAssertEqual(actuals.count, (NSUInteger)1);
    XCTAssertEqual(actuals[0].type, RUNANativeAdAssetDataTypeOther);
    XCTAssertEqualObjects(actuals[0].value, @"value");
}

- (void)testFireClick {
    XCTestExpectation *expectation = [self expectationWithDescription:@"fireClick"];

    RUNANativeAd *ad = [RUNANativeAd new];
    RUNANativeAdAssetLink *link = [RUNANativeAdAssetLink new];
    [link parse:[RUNAJSONObject jsonWithRawDictionary:@{@"url":@"link_url", @"clicktrackers":@[@"clicktrackers"]}]];
    ad.assetLink = link;
    
    [self execute:expectation delayTime:5.0 targetMethod:^{
        [ad fireClick];
    } assertionBlock:^{
        XCTAssertNoThrow(ad);
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testFireImpression {
    XCTestExpectation *expectation = [self expectationWithDescription:@"fireImpression"];

    RUNANativeAd *ad = [RUNANativeAd new];
    RUNANativeAdEventTracker *tracker = [RUNANativeAdEventTracker new];
    [tracker parse:[RUNAJSONObject jsonWithRawDictionary:@{@"url":@"url"}]];    
    ad.eventTrackers = @[tracker];
    
    [self execute:expectation delayTime:5.0 targetMethod:^{
        [ad fireImpression];
    } assertionBlock:^{
        XCTAssertNoThrow(ad);
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end
