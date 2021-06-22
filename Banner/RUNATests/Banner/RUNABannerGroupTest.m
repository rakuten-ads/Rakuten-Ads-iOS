//
//  RUNABannerGroupTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/21.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNATests+Extension.h"
#import "RUNABannerGroup.h"
#import "RUNABannerGroupInner.h"
#import "RUNABannerViewInner.h"
#import "RUNABannerView+Mock.h"

typedef void(^RUNABannerGroupEventHandler)(RUNABannerGroup* group, RUNABannerView* __nullable view, struct RUNABannerViewEvent event);

@interface RUNABannerGroup (Spy)
@property (nonatomic) RUNABannerViewState state;
@property (nonatomic, readonly) NSDictionary<NSString*, RUNABannerView*> *bannerDict;
@property (nonatomic, nullable, copy) RUNABannerGroupEventHandler eventHandler;
@property (nonatomic) RUNABannerViewError error;
- (instancetype)init;
- (NSArray<RUNABannerView*> *)banners;
- (void)triggerFailure;
- (id<RUNAAdInfo>)parse:(NSDictionary *)bid;
- (NSString *)descriptionState;
- (NSDictionary *)descriptionDetail;
- (NSString *)versionString;
- (NSString *)description;
@end

@interface RUNABannerGroupTest : XCTestCase
@end

@implementation RUNABannerGroupTest

- (void)testInit {
    RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
    XCTAssertEqual(group.state, RUNA_ADVIEW_STATE_INIT);
}

- (void)testSetBanners {
    // Case: one object
    {
        RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
        [group setBanners:@[[RUNABannerView new]]];
        NSDictionary *actual = group.bannerDict;
        XCTAssertNotNil(actual);
        XCTAssertEqual(actual.allKeys.count, (NSUInteger)1);
        XCTAssertNotNil(actual[group.bannerDict.allKeys[0]]);
    }
    // Case: Two objects
    {
        RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
        [group setBanners:@[[RUNABannerView new], [RUNABannerView new]]];
        NSDictionary *actual = group.bannerDict;
        XCTAssertNotNil(actual);
        XCTAssertEqual(actual.allKeys.count, (NSUInteger)2);
        XCTAssertNotNil(actual[group.bannerDict.allKeys[0]]);
        XCTAssertNotNil(actual[group.bannerDict.allKeys[1]]);
    }
}

- (void)testBanners {
    RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
    [group setBanners:@[[RUNABannerView new], [RUNABannerView new]]];
    NSArray *actuals = [group banners];
    XCTAssertEqual(actuals.count, (NSUInteger)2);
}

- (void)testParse {
    RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
    RUNABanner *banner = [group parse:[RUNABannerView dummyBidData]];
    XCTAssertEqualObjects(banner.impId, @"1/1");
    XCTAssertEqualObjects(banner.html, @"<div></div>");
    XCTAssertEqual(banner.width, 1280);
    XCTAssertEqual(banner.height, 720);
    XCTAssertEqualObjects(banner.measuredURL, @"https://stg-s-evt.rmp.rakuten.co.jp/measured?dat=test");
    XCTAssertEqualObjects(banner.inviewURL, @"https://stg-s-evt.rmp.rakuten.co.jp/inview?dat=test");
    XCTAssertEqualObjects(banner.viewabilityProviderURL, @"https://stg-s-evt.rmp.rakuten.co.jp/viewability?dat=test");
    XCTAssertEqual(banner.advertiseId, 123);
}

- (void)testTriggerFailure {
    {
        // Case: Default
        XCTestExpectation *expectation = [self expectationWithDescription:@"triggerFailure"];
        RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            group.eventHandler = ^(RUNABannerGroup *group, RUNABannerView * _Nullable view, struct RUNABannerViewEvent event) {
                XCTAssertNotNil(group);
                XCTAssertEqual(event.eventType, RUNABannerViewEventTypeGroupFailed);
                XCTAssertEqual(event.error, RUNABannerViewErrorNone);
            };
            [group triggerFailure];
        } assertionBlock:^{
            XCTAssertEqual(group.state, RUNA_ADVIEW_STATE_FAILED);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
    {
        // Case: Return Case1
        XCTestExpectation *expectation = [self expectationWithDescription:@"triggerFailure"];
        RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
        group.state = RUNA_ADVIEW_STATE_FAILED;
        [self execute:expectation delayTime:3.0 targetMethod:^{
            [group triggerFailure];
        } assertionBlock:^{
            XCTAssertEqual(group.state, RUNA_ADVIEW_STATE_FAILED);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
    {
        // Case: Return Case2
        XCTestExpectation *expectation = [self expectationWithDescription:@"triggerFailure"];
        RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
        group.state = RUNA_ADVIEW_STATE_SHOWED;
        [self execute:expectation delayTime:3.0 targetMethod:^{
            [group triggerFailure];
        } assertionBlock:^{
            XCTAssertEqual(group.state, RUNA_ADVIEW_STATE_SHOWED);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
}

- (void)testDescriptionState {
    RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
    group.state = RUNA_ADVIEW_STATE_INIT;
    XCTAssertEqualObjects([group descriptionState], @"INIT");
    group.state = RUNA_ADVIEW_STATE_LOADING;
    XCTAssertEqualObjects([group descriptionState], @"LOADING");
    group.state = RUNA_ADVIEW_STATE_LOADED;
    XCTAssertEqualObjects([group descriptionState], @"LOADED");
    group.state = RUNA_ADVIEW_STATE_FAILED;
    XCTAssertEqualObjects([group descriptionState], @"FAILED");
    group.state = RUNA_ADVIEW_STATE_RENDERING;
    XCTAssertEqualObjects([group descriptionState], @"RENDERING");
    group.state = RUNA_ADVIEW_STATE_MESSAGE_LISTENING;
    XCTAssertEqualObjects([group descriptionState], @"MESSAGE_LISTENING");
    group.state = RUNA_ADVIEW_STATE_SHOWED;
    XCTAssertEqualObjects([group descriptionState], @"SHOWED");
    group.state = RUNA_ADVIEW_STATE_CLICKED;
    XCTAssertEqualObjects([group descriptionState], @"CLICKED");
}

- (void)testVersionString {
    NSString *version = [[[NSBundle bundleForClass:self.class] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    XCTAssertEqualObjects(version, @"0.1.4");
}

- (void)testDescriptionDetail {
    {
        // Case: Default
        RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
        NSDictionary *ext = @{@"key": @"value"};
        group.userExt = ext;
        [group setBanners:@[[RUNABannerView new], [RUNABannerView new]]];
        NSDictionary *actual = [group descriptionDetail];
        XCTAssertEqual(actual.allKeys.count, (NSUInteger)3);
        XCTAssertEqualObjects(actual[@"banners"], group.banners);
        XCTAssertEqualObjects(actual[@"state"], @"INIT");
        XCTAssertEqualObjects(actual[@"user_extension"], ext);
    }
    {
        // Case: NSNull
        RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
        NSDictionary *actual = [group descriptionDetail];
        XCTAssertEqual(actual.allKeys.count, (NSUInteger)3);
        XCTAssertEqualObjects(actual[@"banners"], NSNull.null);
        XCTAssertEqualObjects(actual[@"state"], @"INIT");
        XCTAssertEqualObjects(actual[@"user_extension"], NSNull.null);
    }
}

@end
