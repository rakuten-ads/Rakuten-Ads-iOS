//
//  RUNANativeAdAdapteTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/23.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNANativeAdAdapter.h"

@interface RUNANativeAdAdapter (Spy)
- (instancetype)initWithAdspotId:(NSString *)adspotId;
- (NSArray *)getImp;
- (NSArray<NSString*> *)adspotIdList;
@end

@implementation RUNANativeAdAdapter (Spy)
// TBD
- (instancetype)initWithAdspotId:(NSString *)adspotId {
    self = [super init];
    if (self) {
        self.adspotId = adspotId;
    }
    return self;
}
@end

@interface RUNANativeAdAdapteTest : XCTestCase
@end

@implementation RUNANativeAdAdapteTest

- (void)testGetImp {
    RUNANativeAdAdapter *adapter = [[RUNANativeAdAdapter alloc]initWithAdspotId:@"999"];
//    adapter.adspotId = @"999";
//    NSArray *actuals = [adapter getImp];
//    XCTAssertEqual(actuals.count, (NSUInteger)1);
//    NSString *value = (NSString*)((NSDictionary*)actuals[0])[@"ext"][@"adspot_id"];
//    XCTAssertEqualObjects(value, adapter.adspotId);
}

- (void)testAdspotIdList {
    
}

@end
