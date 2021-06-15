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

@interface RUNABannerAdapterTest : XCTestCase
@end

@implementation RUNABannerAdapterTest

#pragma mark - RUNABanner

- (void)testParse {
    NSDictionary *bidData = [self dummyBidData];
    RUNABanner *banner = [RUNABanner new];
    [banner parse:bidData];
    
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


#pragma mark - Helper Methods

// TODO: To be common
- (NSDictionary *)dummyBidData {
    NSString *path = [[NSBundle bundleForClass:[self class]]pathForResource:@"bid" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];;
    return dic;
}

@end
