//
//  RUNANativeAdAdapteTests.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/23.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNANativeAdAdapter.h"

@interface RUNANativeAdAdapter (Spy)
- (NSArray<NSString*> *)adspotIdList;
@end

@interface RUNANativeAdAdapteTests : XCTestCase
@end

@implementation RUNANativeAdAdapteTests

- (void)testGetImp {
    RUNANativeAdAdapter *adapter = [RUNANativeAdAdapter new];
    adapter.adspotId = @"999";
    NSArray *actuals = [adapter getImp];
    XCTAssertEqual(actuals.count, (NSUInteger)1);
    NSString *value = (NSString*)((NSDictionary*)actuals[0])[@"ext"][@"adspot_id"];
    XCTAssertEqualObjects(value, adapter.adspotId);
}

- (void)testAdspotIdList {
    RUNANativeAdAdapter *adapter = [RUNANativeAdAdapter new];
    NSArray *list = [adapter adspotIdList];
    XCTAssertNil(list);
}

@end
