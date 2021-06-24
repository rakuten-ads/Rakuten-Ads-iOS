//
//  RUNANativeAdTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/24.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import <RUNACore/RUNAJSONObject.h>
#import "RUNANativeAd.h"
#import "RUNANativeAdInner.h"
#import "RUNABannerView+Mock.h"

@interface RUNANativeAd (Spy)
//+ (instancetype)parse:(NSDictionary *)bidData;
@end

@interface RUNANativeAdTest : XCTestCase
@end

@implementation RUNANativeAdTest

#pragma mark - RUNANativeAd

- (void)testParse {
//    RUNANativeAd *ad = [RUNANativeAd parse:[RUNABannerView dummyBidData]];
}

@end
