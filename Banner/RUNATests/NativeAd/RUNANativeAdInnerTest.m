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
@property(nonatomic, readonly, getter=isRequired) BOOL required;
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

@end
