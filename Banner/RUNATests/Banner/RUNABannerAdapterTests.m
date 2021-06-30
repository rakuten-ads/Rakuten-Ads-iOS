//
//  RUNABannerAdapterTests.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/15.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNABannerAdapter.h"

@interface RUNABanner (Spy)
- (void)parse:(NSDictionary *)bidData;
@end

@interface RUNABannerAdapter (Spy)
- (void)parse:(NSDictionary *)bidData;
- (NSArray *)getImp;
@end

@interface RUNABannerAdapterTests : XCTestCase
@end

@implementation RUNABannerAdapterTests

#pragma mark - RUNABanner

- (void)testParse {
    RUNABanner *banner = [RUNABanner new];
    [banner parse:[self dummyBidData]];
    // FIXME: json value
    XCTAssertEqualObjects(banner.impId, @"1/1");
    XCTAssertEqualObjects(banner.html, @"<div></div>");
    XCTAssertEqual(banner.width, 1280);
    XCTAssertEqual(banner.height, 720);
    XCTAssertEqualObjects(banner.measuredURL, @"https://dev-s-evt.rmp.rakuten.co.jp/measured?dat=test");
    XCTAssertEqualObjects(banner.inviewURL, @"https://dev-s-evt.rmp.rakuten.co.jp/inview?dat=test");
    XCTAssertEqualObjects(banner.viewabilityProviderURL, @"https://dev-s-evt.rmp.rakuten.co.jp/viewability?dat=test");
    XCTAssertEqual(banner.advertiseId, 123);
}

#pragma mark - RUNABannerAdapter

- (void)testGetImp {
    RUNABannerImp *imp;
    {   // Case: default
        imp = [RUNABannerImp new];
        imp.id = @"id";
        imp.adspotId = @"adspotId";
        imp.banner = @{@"api": @[@(7)]}; // default value
        imp.json = [[NSMutableDictionary alloc]initWithDictionary:@{@"key": @"value"}];
        RUNABannerAdapter *bannerAdapter = [RUNABannerAdapter new];
        bannerAdapter.impList = @[imp];
        NSArray *actuals = bannerAdapter.getImp;
        XCTAssertEqual(actuals.count, (NSUInteger)1);
        XCTAssertEqualObjects(actuals[0][@"id"], @"id");
        XCTAssertEqualObjects(actuals[0][@"banner"], @{@"api": @[@(7)]});
        XCTAssertNotNil(actuals[0][@"ext"]);
        XCTAssertEqualObjects(actuals[0][@"ext"][@"adspot_id"], @"adspotId");
        XCTAssertEqualObjects(actuals[0][@"ext"][@"json"], @{@"key": @"value"});
    }
    {
        // Case: empty
        RUNABannerAdapter *bannerAdapter = [RUNABannerAdapter new];
        bannerAdapter.impList = @[[RUNABannerImp new]];
        NSArray *actuals = bannerAdapter.getImp;
        XCTAssertEqual(actuals.count, (NSUInteger)1);
        XCTAssertEqualObjects(actuals[0][@"id"], NSNull.null);
        XCTAssertEqualObjects(actuals[0][@"banner"], NSNull.null);
        XCTAssertNotNil(actuals[0][@"ext"]);
        XCTAssertEqualObjects(actuals[0][@"ext"][@"adspot_id"], NSNull.null);
        XCTAssertEqualObjects(actuals[0][@"ext"][@"json"], NSNull.null);
    }
    {
        // Case: null
        RUNABannerAdapter *bannerAdapter = [RUNABannerAdapter new];
        NSArray *actuals = bannerAdapter.getImp;
        XCTAssertEqual(actuals.count, (NSUInteger)0);
    }
}

- (void)testGetApp {
    {
        // Case: default
        NSDictionary *content = @{
            @"title" : @"title",
            @"keywords" : @"keywords",
            @"url" : @"url"
        };
        RUNABannerAdapter *bannerAdapter = [RUNABannerAdapter new];
        bannerAdapter.appContent = content;
        NSDictionary *appContent = bannerAdapter.getApp;
        XCTAssertNotNil(appContent);
        XCTAssertEqual(appContent.allKeys.count, (NSUInteger)1);
        NSDictionary *value = appContent[@"content"];
        XCTAssertEqual(value.allKeys.count, (NSUInteger)3);
    }
    {
        // Case: empty
        RUNABannerAdapter *bannerAdapter = [RUNABannerAdapter new];
        NSDictionary *appContent = bannerAdapter.getApp;
        XCTAssertNotNil(appContent);
        XCTAssertEqual(appContent.allKeys.count, (NSUInteger)0);
    }
}

- (void)testGetUser {
    {
        // Case: default
        NSDictionary *content = @{
            @"rz" : @"rz"
        };
        RUNABannerAdapter *bannerAdapter = [RUNABannerAdapter new];
        bannerAdapter.userExt = content;
        NSDictionary *userExt = bannerAdapter.getUser;
        XCTAssertNotNil(userExt);
        XCTAssertEqual(userExt.allKeys.count, (NSUInteger)1);
        NSDictionary *value = userExt[@"ext"];
        XCTAssertEqual(value.allKeys.count, (NSUInteger)1);
    }
    {
        // Case: empty
        RUNABannerAdapter *bannerAdapter = [RUNABannerAdapter new];
        NSDictionary *userExt = bannerAdapter.getUser;
        XCTAssertNotNil(userExt);
        XCTAssertEqual(userExt.allKeys.count, (NSUInteger)0);
    }
}

- (void)testGetGeo {
    {
        // Case: default
        RUNAGeo *content = [RUNAGeo new];
        content.latitude = 100.0;
        content.longitude = 120.0;
        RUNABannerAdapter *bannerAdapter = [RUNABannerAdapter new];
        bannerAdapter.geo = content;
        NSDictionary *geo = bannerAdapter.getGeo;
        XCTAssertNotNil(geo);
        XCTAssertEqual(geo.allKeys.count, (NSUInteger)2);
    }
    {
        // Case: nil
        RUNABannerAdapter *bannerAdapter = [RUNABannerAdapter new];
        NSDictionary *geo = bannerAdapter.getGeo;
        XCTAssertNil(geo);
    }
}

- (void)testGetExt {
    {
        // Case: default
        NSArray *items = @[@(1),@(2),@(3)];
        RUNABannerAdapter *bannerAdapter = [RUNABannerAdapter new];
        bannerAdapter.blockAdList = items;
        NSDictionary *ext = bannerAdapter.getExt;
        XCTAssertNotNil(ext);
        XCTAssertEqualObjects(ext[@"badvid"], items);
    }
    {
        // Case: empty
        RUNABannerAdapter *bannerAdapter = [RUNABannerAdapter new];
        NSDictionary *ext = bannerAdapter.getExt;
        XCTAssertEqualObjects(ext[@"badvid"], @[]);
    }
}

- (void)testDescription {
    RUNAGeo *geo = [RUNAGeo new];
    geo.latitude = 100.0;
    geo.longitude = 120.0;
    XCTAssertEqualObjects(geo.description, @"{ lat: 100.000000, lon: 120.000000 }");
}

#pragma mark - Helper Methods

- (NSDictionary *)dummyBidData {
    NSString *path = [[NSBundle bundleForClass:[self class]]pathForResource:@"bid" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];;
    return dic;
}

@end
