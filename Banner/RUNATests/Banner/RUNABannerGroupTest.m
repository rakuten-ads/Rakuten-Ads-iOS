//
//  RUNABannerGroupTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/21.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
// FIXME:
#import "RUNATests+Extension.h"
#import "RUNABannerGroup.h"
#import "RUNABannerViewInner.h"

@interface RUNABannerGroup (Spy)
@property (nonatomic, readonly) RUNABannerViewState state;
@property (nonatomic, readonly) NSDictionary<NSString*, RUNABannerView*> *bannerDict;
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
    RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
    XCTestExpectation *expectation = [self expectationWithDescription:@"triggerFailure"];

    [self execute:expectation delayTime:3.0 targetMethod:^{
        [group triggerFailure];
    } assertionBlock:^{
        //XCTAssertFalse(bannerView.hidden);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end
