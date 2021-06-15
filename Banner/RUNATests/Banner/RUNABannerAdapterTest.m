//
//  RUNABannerAdapterTest.m
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

@interface RUNABannerAdapterTest : XCTestCase
@property (nonatomic) RUNABanner *banner;
@end

@implementation RUNABannerAdapterTest
@synthesize banner = _banner;

#pragma mark - RUNABanner

- (void)setUp {
    // TODO: temp setUp
    self.banner = [RUNABanner new];
    [self.banner parse:[self dummyBidData]];
}

- (void)testParse {
    RUNABanner *banner = self.banner;
    // FIXME: fix json value
    XCTAssertEqualObjects(banner.impId, @"1/1");
    XCTAssertEqualObjects(banner.html, @"<div></div>");
    XCTAssertEqual(banner.width, 1280);
    XCTAssertEqual(banner.height, 720);
    XCTAssertEqualObjects(banner.measuredURL, @"https://stg-s-evt.rmp.rakuten.co.jp/measured?dat=test");
    XCTAssertEqualObjects(banner.inviewURL, @"https://stg-s-evt.rmp.rakuten.co.jp/inview?dat=test");
    XCTAssertEqualObjects(banner.viewabilityProviderURL, @"https://stg-s-evt.rmp.rakuten.co.jp/viewability?dat=test");
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

#pragma mark - Helper Methods

// TODO: To be common
- (NSDictionary *)dummyBidData {
    NSString *path = [[NSBundle bundleForClass:[self class]]pathForResource:@"bid" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];;
    return dic;
}

@end
