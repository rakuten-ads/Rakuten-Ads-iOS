//
//  RUNANativeAdInnerTest.m
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
@property(nonatomic) NSString *url;
@property(nonatomic) int w;
@property(nonatomic) int h;
@property(nonatomic) int type;
- (void)parse:(RUNAJSONObject *)assetJson;
- (NSString *)description;
@end

@interface RUNANativeAdInnerTest : XCTestCase
@end

@implementation RUNANativeAdInnerTest

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

- (void)testParseImage {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"img.url":@"url", @"img.w":@320, @"img.h":@50, @"img.type": @1}];
    {
        RUNANativeAdAssetImage *asset = [RUNANativeAdAssetImage new];
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        XCTAssertEqualObjects(asset.url, @"url");
        XCTAssertEqual(asset.w, 320);
        XCTAssertEqual(asset.h, 50);
        XCTAssertEqual(asset.type, RUNANativeAdAssetImageTypeIcon);
        XCTAssertEqualObjects([asset description], @"[Asset Image] Icon: url");
    }
    {
        RUNANativeAdAssetImage *asset = [RUNANativeAdAssetImage new];
        dic[@"img.type"] = @3;
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        XCTAssertEqual(asset.type, RUNANativeAdAssetImageTypeMain);
        XCTAssertEqualObjects([asset description], @"[Asset Image] Main: url");
    }
    {
        RUNANativeAdAssetImage *asset = [RUNANativeAdAssetImage new];
        dic[@"img.type"] = @500;
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        XCTAssertEqual(asset.type, RUNANativeAdAssetImageTypeOther);
        XCTAssertEqualObjects([asset description], @"[Asset Image] unkown: url");
    }
    {
        RUNANativeAdAssetImage *asset = [RUNANativeAdAssetImage new];
        dic[@"img.type"] = @0;
        [asset parse:[RUNAJSONObject jsonWithRawDictionary:dic]];
        XCTAssertEqual(asset.type, RUNANativeAdAssetImageTypeOther);
        XCTAssertEqualObjects([asset description], @"[Asset Image] unkown: url");
    }
}

@end
