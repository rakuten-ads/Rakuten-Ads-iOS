//
//  RUNANativeAdProviderTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/28.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNANativeAdInner.h"
#import "RUNANativeAdAdapter.h"

typedef void (^RUNANativeAdEventHandler)(RUNANativeAdProvider* loader, NSArray<RUNANativeAd*>* adsList);

@interface RUNANativeAdProvider (Spy)
@property (nonatomic) RUNANativeAdEventHandler handler;
- (void)onBidResponseFailed:(NSHTTPURLResponse *)response error:(NSError *)error;
- (void)onBidResponseSuccess:(nonnull NSArray<RUNANativeAd*> *)adInfoList;
- (RUNANativeAd*)parse:(NSDictionary *)bid;
@end

@interface RUNANativeAdProviderTest : XCTestCase
@property (nonatomic) RUNANativeAdProvider *provider;
@end

@implementation RUNANativeAdProviderTest
@synthesize provider = _provider;

- (void)setUp {
    NSString *dummyId = @"111";
    self.provider = [[RUNANativeAdProvider alloc]initWithAdSpotId:dummyId];
}

- (void)testInit {
    XCTAssertEqualObjects(self.provider.adSpotId, @"111");
}

- (void)testLoad {
    XCTAssertNoThrow([self.provider loadWithCompletionHandler:nil]);
}

- (void)testTriggerFailure {
    RUNANativeAdProvider *adProvider = [[RUNANativeAdProvider alloc]initWithAdSpotId:@""];
    [adProvider loadWithCompletionHandler:^(RUNANativeAdProvider * _Nonnull provider, NSArray<RUNANativeAd *> * _Nonnull adsList) {
        XCTAssertEqual(adsList.count, (NSUInteger)0);
    }];
}

- (void)testOnBidResponseFailed {
    self.provider.handler = ^(RUNANativeAdProvider *loader, NSArray<RUNANativeAd *> *adsList) {
        XCTAssertEqual(adsList.count, (NSUInteger)0);
    };
    [self.provider onBidResponseFailed:nil error:nil];
}

- (void)testOnBidResponseSuccess {
    self.provider.handler = ^(RUNANativeAdProvider *loader, NSArray<RUNANativeAd *> *adsList) {
        XCTAssertEqual(adsList.count, (NSUInteger)2);
    };
    [self.provider onBidResponseSuccess:@[[RUNANativeAd new], [RUNANativeAd new]]];
}

- (void)testParse {
    // NOTE: RUNANativeAd#parse test is implemeted on RUNANativeAdInnerTest.
    NSString *jsonString = @"{\"dummy\":{\"id\":1,\"type\":\"type\"}}"; // mock json for parse
    XCTAssertNotNil([self.provider parse:@{@"adm":jsonString}]);
}

@end
