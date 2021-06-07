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
@property (nonatomic) RUNABannerViewState state;
@property (nonatomic, readonly) RUNABannerViewError error;
@property (nonatomic, readonly) RUNAVideoState videoState;
@property (nonatomic, readonly) RUNAMediaType mediaType;
- (void)setInitState;
- (BOOL)disabledLoad;
- (void)applyAdView;
- (void)playVideo;
- (void)pauseVideo;
@end

@interface RUNABannerViewInnerTest : XCTestCase
@end

@implementation RUNABannerViewInnerTest

- (void)testIntialize {
    RUNABannerView *bannerView = [[RUNABannerView alloc]initWithFrame:CGRectZero];
    XCTAssertNotNil(bannerView.imp);
    XCTAssertNotNil(bannerView.imp.json);
    XCTAssertEqual(bannerView.imp.json.allKeys.count, (NSUInteger)0);
    // Initial State
    XCTAssertTrue(bannerView.hidden);
    XCTAssertEqual(bannerView.state, RUNA_ADVIEW_STATE_INIT);
    XCTAssertEqual(bannerView.error, RUNABannerViewErrorNone);
    XCTAssertEqual(bannerView.videoState, RUNA_VIDEO_STATE_UNKNOWN);
    XCTAssertEqual(bannerView.mediaType, RUNA_MEDIA_TYPE_UNKOWN);
    XCTAssertNotNil(bannerView.measurers);
    XCTAssertNotNil(bannerView.logAdInfo);
    XCTAssertNotNil(bannerView.logUserInfo);
}

- (void)testDisabledLoad {
    RUNABannerView *bannerView = [[RUNABannerView alloc]initWithFrame:CGRectZero];
    XCTAssertFalse([bannerView disabledLoad]);
    bannerView.state = RUNA_ADVIEW_STATE_LOADING;
    XCTAssertTrue([bannerView disabledLoad]);
    bannerView.state = RUNA_ADVIEW_STATE_LOADED;
    XCTAssertTrue([bannerView disabledLoad]);
    bannerView.state = RUNA_ADVIEW_STATE_FAILED;
    XCTAssertFalse([bannerView disabledLoad]);
    bannerView.state = RUNA_ADVIEW_STATE_RENDERING;
    XCTAssertTrue([bannerView disabledLoad]);
    bannerView.state = RUNA_ADVIEW_STATE_MESSAGE_LISTENING;
    XCTAssertTrue([bannerView disabledLoad]);
    bannerView.state = RUNA_ADVIEW_STATE_SHOWED;
    XCTAssertFalse([bannerView disabledLoad]);
    bannerView.state = RUNA_ADVIEW_STATE_CLICKED;
    XCTAssertFalse([bannerView disabledLoad]);
}

// TODO: implement tests
// load
// loadWithEventHandler
// triggerSuccess
// triggerFailure

- (void)testScriptMessageEvent {
    RUNABannerView *actual;
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];
    expectation.expectedFulfillmentCount = 6;

    // Case: expand
    actual = [[RUNABannerView alloc]initWithEventType:@"expand"];
    [self execute:expectation delayTime:1.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.mediaType, RUNA_MEDIA_TYPE_BANNER);
        XCTAssertEqual(actual.state, RUNA_ADVIEW_STATE_SHOWED);
    }];
    
    // Case: collapse
    actual = [[RUNABannerView alloc]initWithEventType:@"collapse"];
    [self execute:expectation delayTime:1.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.state, RUNA_ADVIEW_STATE_FAILED);
    }];
    
    // Case: register
    actual = [[RUNABannerView alloc]initWithEventType:@"register"];
    [self execute:expectation delayTime:1.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.state, RUNA_ADVIEW_STATE_MESSAGE_LISTENING);
    }];
    
    // Case: unfilled
    actual = [[RUNABannerView alloc]initWithEventType:@"unfilled"];
    [self execute:expectation delayTime:1.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.error, RUNABannerViewErrorUnfilled);
        XCTAssertEqual(actual.state, RUNA_ADVIEW_STATE_FAILED);
    }];
    
    // Case: video
    actual = [[RUNABannerView alloc]initWithEventType:@"video"];
    [self execute:expectation delayTime:1.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.mediaType, RUNA_MEDIA_TYPE_VIDEO);
    }];
    
    // Case: video_loaded
    actual = [[RUNABannerView alloc]initWithEventType:@"video_loaded"];
    [self execute:expectation delayTime:1.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.videoState, RUNA_VIDEO_STATE_LOADED);
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testEvaluateJavaScript {
    RUNABannerView *actual = [[RUNABannerView alloc]initWithEventType:@"video_loaded"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];
    expectation.expectedFulfillmentCount = 3;
    
    // Case: InitialStatus
    XCTAssertEqual(actual.mediaType, RUNA_MEDIA_TYPE_UNKOWN);
    XCTAssertEqual(actual.videoState, RUNA_VIDEO_STATE_UNKNOWN);
    
    // Case: PlayVideo
    [self execute:expectation delayTime:1.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.videoState, RUNA_VIDEO_STATE_LOADED);
        [actual playVideo];
    }];
    [self execute:expectation delayTime:3.0 targetMethod:^{
    } assertionBlock:^{
        XCTAssertEqual(actual.videoState, RUNA_VIDEO_STATE_PLAYING);
        [actual pauseVideo];
    }];
    
    // Case: PauseVideo
    [self execute:expectation delayTime:5.0 targetMethod:^{
    } assertionBlock:^{
        XCTAssertEqual(actual.videoState, RUNA_VIDEO_STATE_PAUSED);
    }];
    
    [self waitForExpectationsWithTimeout:7.0 handler:nil];
}

- (void)execute:(XCTestExpectation *)expectation
      delayTime:(int64_t)delayTime
   targetMethod:(void (^)(void))targetMethod
 assertionBlock:(void (^)(void))assertionBlock {
    targetMethod();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayTime * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        assertionBlock();
        [expectation fulfill];
    });
}

@end
