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
@end

@implementation RUNABannerViewInnerTest

- (void)testVideoState {
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];
    RUNABannerView *actual = [[RUNABannerView alloc]initWithEventType:@"video_loaded"];
    [actual applyAdView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        XCTAssertEqual(actual.videoState, RUNA_VIDEO_STATE_LOADED);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

@end
