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
#import "RUNABannerViewInner.h"

typedef void(^RUNABannerGroupEventHandler)(RUNABannerGroup* group, RUNABannerView* __nullable view, struct RUNABannerViewEvent event);

@interface RUNABannerGroup (Spy)
@property (nonatomic) RUNABannerViewState state;
@property (nonatomic, readonly) NSDictionary<NSString*, RUNABannerView*> *bannerDict;
@property (nonatomic, nullable, copy) RUNABannerGroupEventHandler eventHandler;
@property (nonatomic) RUNABannerViewError error;
- (instancetype)init;
- (NSArray<RUNABannerView*>*)banners;
- (void)triggerFailure;
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

// TODO: Implementation
- (void)testParse {
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

@end
