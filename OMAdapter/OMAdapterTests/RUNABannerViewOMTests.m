//
//  OMAdapterTests.m
//  OMAdapterTests
//
//  Created by Wu, Wei b on R 2/03/05.
//  Copyright © Reiwa 2 RUNA. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNABannerViewOMInner.h"

@interface RUNABannerViewOMTests : XCTestCase

@end

@implementation RUNABannerViewOMTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInit {
    RUNABannerView* bannerView = [RUNABannerView new];
    XCTAssertEqual(((NSArray*)bannerView.imp.banner[@"api"]).firstObject, @(7));
    XCTAssertNil(bannerView.userId);
    XCTAssertNil(bannerView.userExt);
}

- (void)testDisableMeasurement {
    RUNABannerView* bannerView = [RUNABannerView new];
    XCTAssertFalse(bannerView.openMeasurementDisabled);

    [bannerView openMeasurementDisabled];
    XCTAssertFalse(bannerView.openMeasurementDisabled);
}

- (void)testGetMeasurer {
    XCTestExpectation *expectation = [self expectationWithDescription:@"async load test"];
    
    RUNABannerView* bannerView = [RUNABannerView new];
    bannerView.adSpotId = @"996";
    [bannerView loadWithEventHandler:^(RUNABannerView * _Nonnull view, struct RUNABannerViewEvent event) {
        if (event.eventType == RUNABannerViewEventTypeSucceeded) {
            XCTAssertNotNil(bannerView.measurers);
            XCTAssertTrue(bannerView.measurers.count > 0);
        } else {
            XCTFail("load failed");
        }
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end
