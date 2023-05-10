//
//  RUNAInterstitialAdTests.m
//  BannerTests
//
//  Created by Wu, Wei | David | GATD on 2023/05/10.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAInterstitialAdInner.h"

@interface RUNAInterstitialAd(test)

-(void) close;

@end

@interface RUNAInterstitialAdTests : XCTestCase

@end

@implementation RUNAInterstitialAdTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testNil {
    RUNAInterstitialAd* ad = [RUNAInterstitialAd new];
    XCTAssertNoThrow([ad preloadWithEventHandler:nil]);
}

- (void)testFaildEvent {
    RUNAInterstitialAd* ad = [RUNAInterstitialAd new];
    ad.adSpotId = @"000";

    XCTestExpectation *expectation = [self expectationWithDescription:@"InterstitialLoad"];

    [ad preloadWithEventHandler:^(RUNAInterstitialAd * _Nonnull adView, struct RUNABannerViewEvent event) {
        XCTAssertNotNil(adView);
        XCTAssertEqual(event.eventType, RUNABannerViewEventTypeFailed);
        [adView close];
        [expectation fulfill];
    }];

    XCTAssertFalse([ad showIn:nil]);

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testSuccessEvent {
    RUNAInterstitialAd* ad = [RUNAInterstitialAd new];
    ad.adSpotId = @"996";

    XCTestExpectation *expectation = [self expectationWithDescription:@"InterstitialLoad"];

    [ad preloadWithEventHandler:^(RUNAInterstitialAd * _Nonnull adView, struct RUNABannerViewEvent event) {
        XCTAssertNotNil(adView);
        XCTAssertEqual(event.eventType, RUNABannerViewEventTypeSucceeded);
        [expectation fulfill];
    }];

    XCTAssertTrue(ad.adContentView.imp.isInterstitial);

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testShow {
    RUNAInterstitialAd* ad = [RUNAInterstitialAd new];
    RUNABannerView* banner = [RUNABannerView new];
    banner.adSpotId = @"996";
    [banner setRz:@"rzcookie"];

    ad.adContentView = banner;

    XCTestExpectation *expectation = [self expectationWithDescription:@"InterstitialShow"];

    [ad preloadWithEventHandler:^(RUNAInterstitialAd * _Nonnull adView, struct RUNABannerViewEvent event) {
        switch (event.eventType) {
            case RUNABannerViewEventTypeSucceeded:
            {
                XCTAssertNoThrow([ad preloadWithEventHandler:nil]);
                UIViewController* parentCtrl = [UIViewController new];
                [adView showIn:parentCtrl];
                [adView close];
                [expectation fulfill];
                break;
            }
            default:
                break;
        }
    }];

    XCTAssertTrue(ad.adContentView.imp.isInterstitial);

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testShowSizeOriginal {
    RUNAInterstitialAd* ad = [RUNAInterstitialAd new];
    ad.adSpotId = @"996";
    ad.size = RUNAInterstitialAdSizeOriginal;

    XCTestExpectation *expectation = [self expectationWithDescription:@"InterstitialShow"];

    [ad preloadWithEventHandler:^(RUNAInterstitialAd * _Nonnull adView, struct RUNABannerViewEvent event) {
        switch (event.eventType) {
            case RUNABannerViewEventTypeSucceeded:
            {
                XCTAssertNoThrow([ad preloadWithEventHandler:nil]);
                UIViewController* parentCtrl = [UIViewController new];
                [adView showIn:parentCtrl];
                [adView close];
                [expectation fulfill];
                break;
            }
            default:
                break;
        }
    }];

    XCTAssertTrue(ad.adContentView.imp.isInterstitial);

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testShowSizeCustom {
    RUNAInterstitialAd* ad = [RUNAInterstitialAd new];
    ad.adSpotId = @"996";
    ad.size = RUNAInterstitialAdSizeCustom;
    ad.decorator = ^(UIView *const  _Nonnull containerView, UIView *const  _Nonnull adView, UIImageView *const  _Nonnull closeButton) {
        XCTAssertNotNil(containerView);
        XCTAssertNotNil(adView);
        XCTAssertNotNil(closeButton);
    };

    XCTestExpectation *expectation = [self expectationWithDescription:@"InterstitialShow"];

    [ad preloadWithEventHandler:^(RUNAInterstitialAd * _Nonnull adView, struct RUNABannerViewEvent event) {
        switch (event.eventType) {
            case RUNABannerViewEventTypeSucceeded:
            {
                XCTAssertNoThrow([ad preloadWithEventHandler:nil]);
                UIViewController* parentCtrl = [UIViewController new];
                [adView showIn:parentCtrl];
                [adView close];
                [expectation fulfill];
                break;
            }
            default:
                break;
        }
    }];

    XCTAssertTrue(ad.adContentView.imp.isInterstitial);

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end
