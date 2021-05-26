//
//  RUNABannerViewInnerTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/05/25.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNABannerView+Stub.h"
#import "RUNABannerViewInner.h"

@interface RUNABannerView (Spy)
@property (nonatomic) RUNABanner *banner;
@property (nonatomic) RUNAVideoState videoState;
- (void)applyAdView;
@end

@interface RUNABannerViewInnerTest : XCTestCase
@property (nonatomic) RUNABannerView *bannerView;
@end

@implementation RUNABannerViewInnerTest
@synthesize bannerView = _bannerView;

- (void)setUp {
    NSDictionary *dummyResponse = @{@"adm":@"<script type=\"text/javascript\">window.onload = function() {window.webkit.messageHandlers.runaSdkInterface.postMessage({\"type\":\"video_loaded\"});}</script>"};
    self.bannerView = [[RUNABannerView alloc]initWithBidResponse:dummyResponse];
}

- (void)testVideoState {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test"];
    [self.bannerView applyAdView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        XCTAssertEqual(self.bannerView.videoState, RUNA_VIDEO_STATE_LOADED);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

@end
