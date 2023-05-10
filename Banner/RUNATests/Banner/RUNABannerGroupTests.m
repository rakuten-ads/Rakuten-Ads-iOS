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
#import "RUNABannerGroupExtension.h"
#import "RUNABannerViewInner.h"
#import "RUNABannerAdapter.h"
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
- (void)onBidResponseFailed:(nonnull NSHTTPURLResponse *)response error:(nullable NSError *)error;
- (void)onBidResponseSuccess:(nonnull NSArray<RUNABanner*> *)adInfoList withSessionId:(nonnull NSString *)sessionId;
- (NSString *)descriptionState;
- (NSDictionary *)descriptionDetail;
- (NSString *)versionString;
@end

@interface RUNABannerGroupTests : XCTestCase
@end

@implementation RUNABannerGroupTests

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

// Test to confirm the passage of method for coverage
- (void)testLoad {
    RUNABannerGroupEventHandler emptyHandler = ^(RUNABannerGroup * _Nonnull group, RUNABannerView * _Nullable view, struct RUNABannerViewEvent event) {
    };
    {
        // Case: BannerDict count is 0
        RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
        XCTAssertNoThrow([group load]);
    }
    {
        // Case: Not load state RUNA_ADVIEW_STATE_LOADING
        RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
        XCTestExpectation *expectation = [self expectationWithDescription:@"load"];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            group.state = RUNA_ADVIEW_STATE_LOADING;
            [group loadWithEventHandler:emptyHandler];
        } assertionBlock:^{
            XCTAssertNil(group.eventHandler);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
    {
        // Case: Not load state RUNA_ADVIEW_STATE_LOADED
        RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
        XCTestExpectation *expectation = [self expectationWithDescription:@"load"];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            group.state = RUNA_ADVIEW_STATE_LOADED;
            [group loadWithEventHandler:emptyHandler];
        } assertionBlock:^{
            XCTAssertNil(group.eventHandler);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
    {
        // Case: Empty adSpotId
        RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
        [group setBanners:@[[RUNABannerView new]]];
        XCTestExpectation *expectation = [self expectationWithDescription:@"load"];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            [group loadWithEventHandler:emptyHandler];
        } assertionBlock:^{
            XCTAssertEqual(group.error, RUNABannerViewErrorFatal);
            XCTAssertNotNil(group.eventHandler);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
    {
        // Case: Default
        RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
        RUNABannerView *bannerView = [RUNABannerView new];
        bannerView.adSpotId = @"111";
        [group setBanners:@[bannerView]];
        XCTestExpectation *expectation = [self expectationWithDescription:@"load"];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            XCTAssertNoThrow([group loadWithEventHandler:emptyHandler]);
        } assertionBlock:^{
            XCTAssertNotNil(group.eventHandler);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
}

- (void)testParse {
    RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
    RUNABanner *banner = [group parse:[RUNABannerView dummyBidData]];
    XCTAssertEqualObjects(banner.impId, @"1/1");
    XCTAssertEqualObjects(banner.html, @"<div></div>");
    XCTAssertEqual(banner.width, 1280);
    XCTAssertEqual(banner.height, 720);
    XCTAssertEqualObjects(banner.measuredURL, @"https://dev-s-evt.rmp.rakuten.co.jp/measured?dat=test");
    XCTAssertEqualObjects(banner.inviewURL, @"https://dev-s-evt.rmp.rakuten.co.jp/inview?dat=test");
    XCTAssertEqualObjects(banner.viewabilityProviderURL, @"https://dev-s-evt.rmp.rakuten.co.jp/viewability?dat=test");
    XCTAssertEqual(banner.advertiseId, 123);
}

- (void)testOnBidResponseFailed {
    RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
    NSURL *url = [[NSURL alloc]initWithString:@"dummyUrl"];
    {
        // Case: Unfilled
        XCTestExpectation *expectation = [self expectationWithDescription:@"onBidResponseFailed"];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            NSHTTPURLResponse *mockResponse = [[NSHTTPURLResponse alloc]initWithURL:url statusCode:kRUNABidResponseUnfilled HTTPVersion:nil headerFields:nil];
            [group onBidResponseFailed:mockResponse error:nil];
        } assertionBlock:^{
            XCTAssertEqual(group.error, RUNABannerViewErrorUnfilled);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
    {
        // Case: Error
        XCTestExpectation *expectation = [self expectationWithDescription:@"onBidResponseFailed"];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            NSHTTPURLResponse *mockResponse = [[NSHTTPURLResponse alloc]initWithURL:url statusCode:400 HTTPVersion:nil headerFields:nil];
            NSError *error = [NSError errorWithDomain:@"dummyDomain" code:400 userInfo:@{}];
            [group onBidResponseFailed:mockResponse error:error];
        } assertionBlock:^{
            XCTAssertEqual(group.error, RUNABannerViewErrorNetwork);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
}

- (void)testOnBidResponseSuccess {
    RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
    [group setBanners:@[[RUNABannerView new]]];
    {
        // Case: Default
        XCTestExpectation *expectation = [self expectationWithDescription:@"onBidResponseSuccess"];
        
        RUNABanner *banner = [RUNABanner new]; // mock
        NSMutableDictionary *bidData = [[NSMutableDictionary alloc]initWithDictionary:[RUNABannerView dummyBidData]];
        bidData[@"impid"] = group.bannerDict.allKeys[0];
        [banner parse:bidData];
        
        [self execute:expectation delayTime:3.0 targetMethod:^{
            [group onBidResponseSuccess:@[banner] withSessionId:@"sessionId"];
        } assertionBlock:^{
            XCTAssertEqual(group.state, RUNA_ADVIEW_STATE_LOADED);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
    {
        // Case: Empty Banner
        XCTestExpectation *expectation = [self expectationWithDescription:@"onBidResponseSuccess"];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            [group onBidResponseSuccess:@[[RUNABanner new]] withSessionId:@"dummyId"];
        } assertionBlock:^{
            XCTAssertEqual(group.state, RUNA_ADVIEW_STATE_LOADED);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
    {
        // Case: Empty Banner
        [group setBanners:@[[RUNABannerView new]]];
        XCTestExpectation *expectation = [self expectationWithDescription:@"onBidResponseSuccess"];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            [group onBidResponseSuccess:@[] withSessionId:@"dummyId"];
        } assertionBlock:^{
            XCTAssertEqual(group.banners.firstObject.state, RUNA_ADVIEW_STATE_FAILED);
            XCTAssertEqual(group.state, RUNA_ADVIEW_STATE_LOADED);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
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
    group.state = -1;
    XCTAssertEqualObjects([group descriptionState], @"unknown");
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

- (void)testSetRz {
    RUNABannerGroup *group = [RUNABannerGroup new];
    [group setRz:@"rzValue"];
    XCTAssertNotNil(group.userExt);
    XCTAssertEqualObjects(group.userExt[@"rz"], @"rzValue");
}

- (void)testSetRp {
    RUNABannerGroup *group = [RUNABannerGroup new];
    [group setRp:@"rpValue"];
    XCTAssertNotNil(group.userId);
    XCTAssertEqualObjects(group.userId, @"rpValue");
}

- (void)testSetRpoint {
    RUNABannerGroup *group = [RUNABannerGroup new];
    [group setRpoint:-1];
    XCTAssertNil(group.userExt);
    XCTAssertEqualObjects(group.userExt[@"rpoint"], nil);

    [group setRpoint:30];
    XCTAssertNotNil(group.userExt);
    XCTAssertEqualObjects(group.userExt[@"rpoint"], @(30));
}

- (void)testSetEasyId {
    RUNABannerGroup *group = [RUNABannerGroup new];
    [group setEasyId:@"GoiGoiSuuuuuuuuuuuu"];
    XCTAssertNotNil(group.userExt);
    XCTAssertEqualObjects(group.userExt[@"hashedeasyid"], @"571002c02f2144a41617487738060992");

}
@end
