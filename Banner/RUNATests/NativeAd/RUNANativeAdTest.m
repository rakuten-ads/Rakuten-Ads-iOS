//
//  RUNANativeAdTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/24.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNANativeAd.h"
#import "RUNANativeAdInner.h"

@interface RUNANativeAd (Spy)
@end

@interface RUNANativeAdTest : XCTestCase
@end

@implementation RUNANativeAdTest

#pragma mark - RUNANativeAd

- (void)testParse {
    {
        // Case: Objects parse
        NSDictionary *link = @{@"url":@"url", @"fallback":@"fallback", @"clicktrackers":@[@"hoge"]}; // Mock link
        NSArray *eventtrackers = @[@{@"url":@"event_url", @"event":@1, @"method":@2}]; // Mock eventtrackers
        NSArray *assets = @[@{@"title":@{}}, @{@"img":@{}}, @{@"data":@{}}]; // Mock assets
        RUNANativeAd *ad = [RUNANativeAd parse:@{@"ext.admnative":@{@"adm":@"</div>",
                                                                    @"link":link,
                                                                    @"eventtrackers":eventtrackers,
                                                                    @"assets":assets,
                                                                    @"privacy":@"privacy_url"}}];
        XCTAssertNotNil(ad);
        XCTAssertNotNil(ad.rawData);
        XCTAssertNotNil(ad.assetTitle);
        XCTAssertNotNil(ad.assetImgs);
        XCTAssertNotNil(ad.assetDatas);
        XCTAssertNotNil(ad.assetLink);
        XCTAssertNotNil(ad.eventTrackers);
        XCTAssertEqualObjects(ad.privacyURL, @"privacy_url");
    }
    {
        // Case: admJson is nil
        XCTAssertNil([RUNANativeAd parse:@{@"key":@"value"}]);
        XCTAssertNil([RUNANativeAd parse:@{@"adm":@"value"}]);
    }
    {
        // Case: admJson from json string
        NSString *jsonString = @"{\"dummy\":{\"id\":1,\"type\":\"type\"}}";
        XCTAssertNotNil([RUNANativeAd parse:@{@"adm":jsonString}]);
    }
}

@end
