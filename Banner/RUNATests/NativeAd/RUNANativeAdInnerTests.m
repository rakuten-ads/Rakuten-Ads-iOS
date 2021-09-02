//
//  RUNANativeAdInnerTests.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/24.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RUNACore/RUNAJSONObject.h>
#import "RUNANativeAd.h"
#import "RUNANativeAdInner.h"

@interface RUNANativeAdAsset (Spy)
@property(nonatomic, readonly) BOOL required;
@end

@interface RUNANativeAdAssetImage (Spy)
@property(nonatomic, readonly) NSString *url;
@property(nonatomic, readonly) int w;
@property(nonatomic, readonly) int h;
@property(nonatomic, readonly) int type;
- (void)parse:(RUNAJSONObject *)assetJson;
@end

@interface RUNANativeAdAssetTitle (Spy)
@property(nonatomic, readonly) NSString *text;
- (void)parse:(RUNAJSONObject *)assetJson;
@end

@interface RUNANativeAdAssetData (Spy)
@property(nonatomic, readonly) NSString *value;
@property(nonatomic, readonly) int type;
@property(nonatomic, readonly) int len;
@property(nonatomic, readonly) NSDictionary *ext;
- (void)parse:(RUNAJSONObject *)assetJson;
@end

@interface RUNANativeAdAssetLink (Spy)
@property(nonatomic, readonly) NSString *url;
@property(nonatomic, readonly) NSString *fallback;
@property(nonatomic, readonly) NSArray<NSString*> *clicktrackers;
- (void)parse:(RUNAJSONObject *)assetJson;
- (NSString *)getUrl;
@end

@interface RUNANativeAdEventTracker (Spy)
@property(nonatomic, readonly) int event;
@property(nonatomic, readonly) int method;
@property(nonatomic, readonly) RUNAURLString *url;
@end

@interface RUNANativeAdInnerTests : XCTestCase
@end

@implementation RUNANativeAdInnerTests

#pragma mark - RUNANativeAdAssetTest

- (void)testParse {
    RUNANativeAdAsset *asset = [RUNANativeAdAsset new];
    [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{ @"required" : @0 }]];
    XCTAssertFalse(asset.required);
    [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{ @"required" : @1 }]];
    XCTAssertTrue(asset.required);
}

- (void)testFactoryAsset {
    {
        RUNANativeAdAsset *asset = [RUNANativeAdAsset factoryAsset:@{}];
        XCTAssertNil(asset);
    }
    {
        RUNANativeAdAsset *asset = [RUNANativeAdAsset factoryAsset:@{@"title":@{}}];
        XCTAssertNotNil(asset);
        XCTAssertTrue([asset isMemberOfClass:RUNANativeAdAssetTitle.class]);
    }
    {
        RUNANativeAdAsset *asset = [RUNANativeAdAsset factoryAsset:@{@"img":@{}}];
        XCTAssertNotNil(asset);
        XCTAssertTrue([asset isMemberOfClass:RUNANativeAdAssetImage.class]);
    }
    {
        RUNANativeAdAsset *asset = [RUNANativeAdAsset factoryAsset:@{@"data":@{}}];
        XCTAssertNotNil(asset);
        XCTAssertTrue([asset isMemberOfClass:RUNANativeAdAssetData.class]);
    }
}

#pragma mark - RUNANativeAdAssetImageTest

- (void)testAssetImage {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"img.url":@"https://www.google.com", @"img.w":@320, @"img.h":@50, @"img.type": @(RUNANativeAdAssetImageTypeIcon)}];
    {
        RUNANativeAdAssetImage *asset = [RUNANativeAdAssetImage new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        XCTAssertEqualObjects(asset.url, @"https://www.google.com");
        XCTAssertEqual(asset.w, 320);
        XCTAssertEqual(asset.h, 50);
        XCTAssertEqual(asset.type, RUNANativeAdAssetImageTypeIcon);
        NSString *description = [NSString stringWithFormat:@"%@", asset];
        XCTAssertEqualObjects(description, @"[Asset Image] Icon: https://www.google.com");
    }
    {
        RUNANativeAdAssetImage *asset = [RUNANativeAdAssetImage new];
        dic[@"img.type"] = @3;
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        XCTAssertEqual(asset.type, RUNANativeAdAssetImageTypeMain);
        NSString *description = [NSString stringWithFormat:@"%@", asset];
        XCTAssertEqualObjects(description, @"[Asset Image] Main: https://www.google.com");
    }
    {
        RUNANativeAdAssetImage *asset = [RUNANativeAdAssetImage new];
        dic[@"img.type"] = @500;
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        XCTAssertEqual(asset.type, RUNANativeAdAssetImageTypeOther);
        NSString *description = [NSString stringWithFormat:@"%@", asset];
        XCTAssertEqualObjects(description, @"[Asset Image] unkown: https://www.google.com");
    }
    {
        RUNANativeAdAssetImage *asset = [RUNANativeAdAssetImage new];
        dic[@"img.type"] = @0;
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        XCTAssertEqual(asset.type, RUNANativeAdAssetImageTypeOther);
        NSString *description = [NSString stringWithFormat:@"%@", asset];
        XCTAssertEqualObjects(description, @"[Asset Image] unkown: https://www.google.com");
    }
}

#pragma mark - RUNANativeAdAssetTitle

- (void)testAssetTitle {
    RUNANativeAdAssetTitle *asset = [RUNANativeAdAssetTitle new];
    [asset parse:[RUNAJSONObject jsonWithRawDictionary:@{@"title.text":@"hogefuga"}]];
    XCTAssertEqualObjects(asset.text, @"hogefuga");
    NSString *description = [NSString stringWithFormat:@"%@", asset];
    XCTAssertEqualObjects(description, @"Asset Title: hogefuga");
}

#pragma mark - RUNANativeAdAssetData

- (void)testAssetData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"data.value":@"value", @"data.type":@(RUNANativeAdAssetDataTypeSponsored), @"data.len":@9999, @"data.ext": @{@"key":@"value"}}];
    {
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        XCTAssertEqualObjects(asset.value, @"value");
        XCTAssertEqual(asset.type, RUNANativeAdAssetDataTypeSponsored);
        XCTAssertEqual(asset.len, 9999);
        XCTAssertEqualObjects(asset.ext, @{@"key":@"value"});
        NSString *description = [NSString stringWithFormat:@"%@", asset];
        XCTAssertEqualObjects(description, @"[Asset Data] sponsored: value");
    }
    {
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        dic[@"data.type"] = @(RUNANativeAdAssetDataTypeDesc);
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        NSString *description = [NSString stringWithFormat:@"%@", asset];
        XCTAssertEqualObjects(description, @"[Asset Data] desc: value");
    }
    {
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        dic[@"data.type"] = @(RUNANativeAdAssetDataTypeRating);
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        NSString *description = [NSString stringWithFormat:@"%@", asset];
        XCTAssertEqualObjects(description, @"[Asset Data] rating: value");
    }
    {
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        dic[@"data.type"] = @(RUNANativeAdAssetDataTypePrice);
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        NSString *description = [NSString stringWithFormat:@"%@", asset];
        XCTAssertEqualObjects(description, @"[Asset Data] price: value");
    }
    {
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        dic[@"data.type"] = @(RUNANativeAdAssetDataTypeSaleprice);
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        NSString *description = [NSString stringWithFormat:@"%@", asset];
        XCTAssertEqualObjects(description, @"[Asset Data] saleprice: value");
    }
    {
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        dic[@"data.type"] = @(RUNANativeAdAssetDataTypeCtatext);
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        NSString *description = [NSString stringWithFormat:@"%@", asset];
        XCTAssertEqualObjects(description, @"[Asset Data] ctatext: value");
    }
    {
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        dic[@"data.type"] = @(RUNANativeAdAssetDataTypeOther);
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        NSString *description = [NSString stringWithFormat:@"%@", asset];
        XCTAssertEqualObjects(description, @"[Asset Data] specific: value");
    }
    {
        RUNANativeAdAssetData *asset = [RUNANativeAdAssetData new];
        dic[@"data.type"] = @(-1);
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        NSString *description = [NSString stringWithFormat:@"%@", asset];
        XCTAssertEqualObjects(description, @"[Asset Data] specific: value");
    }
}

#pragma mark - RUNANativeAdAssetLink

- (void)testAssetLink {
    RUNANativeAdAssetLink *asset = [RUNANativeAdAssetLink new];
    NSDictionary *dic = @{@"url":@"https://www.google.com", @"fallback":@"fallback", @"clicktrackers":@[@"hoge", @"fuga"]};
    [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
    XCTAssertEqualObjects(asset.url, @"https://www.google.com");
    XCTAssertEqualObjects(asset.fallback, @"fallback");
    XCTAssertEqual(asset.clicktrackers.count, (NSUInteger)2);
    XCTAssertEqualObjects(asset.clicktrackers[0], @"hoge");
    XCTAssertEqualObjects(asset.clicktrackers[1], @"fuga");
    XCTAssertEqualObjects([asset getUrl], @"https://www.google.com");
    NSString *description = [NSString stringWithFormat:@"%@", asset];
    XCTAssertEqualObjects(description, @"[Asset Link] URL: https://www.google.com");
}

#pragma mark - RUNANativeAdEventTracker

- (void)testAdEventTracker {
    RUNANativeAdEventTracker *asset = [RUNANativeAdEventTracker new];
    NSDictionary *dic = @{@"url":@"https://www.google.com", @"event":@1, @"method":@2};
    [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
    XCTAssertEqualObjects(asset.url, @"https://www.google.com");
    XCTAssertEqual(asset.event, 1);
    XCTAssertEqual(asset.method, 2);
    XCTAssertEqualObjects([asset getUrl], @"https://www.google.com");
    NSString *description = [NSString stringWithFormat:@"%@", asset];
    XCTAssertEqualObjects(description, @"[Native Ad Event Tracker] method=2: https://www.google.com");
}

@end
