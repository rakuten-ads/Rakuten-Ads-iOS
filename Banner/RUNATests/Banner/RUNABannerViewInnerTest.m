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
#import "MainViewController.h"

// for staging
NSString *const kValidAdspotId = @"693";

@interface RUNABannerView (Spy)
@property (nonatomic) RUNABanner *banner;
@property (nonatomic) RUNABannerViewState state;
@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* sizeConstraints;
@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* positionConstraints;
@property (nonatomic, readonly) RUNABannerViewError error;
@property (nonatomic, readonly) RUNAVideoState videoState;
@property (nonatomic, readonly) RUNAMediaType mediaType;
- (void)setInitState;
- (BOOL)isLoading;
- (void)applyAdView;
- (BOOL)isFinished;
- (void)triggerSuccess;
- (void)triggerFailure;
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

# pragma mark - APT Tests

- (void)testIsLoading {
    RUNABannerView *bannerView = [[RUNABannerView alloc]initWithFrame:CGRectZero];
    XCTAssertFalse([bannerView isLoading]);
    bannerView.state = RUNA_ADVIEW_STATE_LOADING;
    XCTAssertTrue([bannerView isLoading]);
    bannerView.state = RUNA_ADVIEW_STATE_LOADED;
    XCTAssertTrue([bannerView isLoading]);
    bannerView.state = RUNA_ADVIEW_STATE_FAILED;
    XCTAssertFalse([bannerView isLoading]);
    bannerView.state = RUNA_ADVIEW_STATE_RENDERING;
    XCTAssertTrue([bannerView isLoading]);
    bannerView.state = RUNA_ADVIEW_STATE_MESSAGE_LISTENING;
    XCTAssertTrue([bannerView isLoading]);
    bannerView.state = RUNA_ADVIEW_STATE_SHOWED;
    XCTAssertFalse([bannerView isLoading]);
    bannerView.state = RUNA_ADVIEW_STATE_CLICKED;
    XCTAssertFalse([bannerView isLoading]);
}

- (void)testLoad {
    RUNABannerView *bannerView = [RUNABannerView new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];
    
    [self execute:expectation delayTime:5.0 targetMethod:^{
        bannerView.adSpotId = kValidAdspotId;
        [bannerView load];
    } assertionBlock:^{
        XCTAssertNil(bannerView.eventHandler);
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testLoadWithEventHandler {
    RUNABannerView *bannerView = [RUNABannerView new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];

    [self execute:expectation delayTime:5.0 targetMethod:^{
        bannerView.adSpotId = kValidAdspotId;
        [bannerView loadWithEventHandler:
         ^(RUNABannerView * _Nonnull view,
           struct RUNABannerViewEvent event) {
            XCTAssertEqual(event.eventType, RUNABannerViewEventTypeSucceeded);
            XCTAssertEqual(bannerView.state, RUNA_ADVIEW_STATE_SHOWED);
        }];
    } assertionBlock:^{
        XCTAssertNotNil(bannerView.eventHandler);
        // onBidResponse Success
        XCTAssertNotNil(bannerView.sessionId);
        XCTAssertNotNil(bannerView.banner);
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testLoadWithEventHandlerFailure {
    RUNABannerView *bannerView = [RUNABannerView new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];

    [self execute:expectation delayTime:5.0 targetMethod:^{
        bannerView.adSpotId = @"0001"; // Invalid adSpotId
        [bannerView loadWithEventHandler:
         ^(RUNABannerView * _Nonnull view,
           struct RUNABannerViewEvent event) {
            XCTAssertEqual(event.eventType, RUNABannerViewEventTypeFailed);
            XCTAssertEqual(bannerView.state, RUNA_ADVIEW_STATE_FAILED);
        }];
    } assertionBlock:^{
        XCTAssertNotNil(bannerView.eventHandler);
        // onBidResponse Failure
        XCTAssertNil(bannerView.sessionId);
        XCTAssertNil(bannerView.banner);
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testSetSize {
    RUNABannerView *bannerView = [RUNABannerView new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];
    
    XCTAssertEqual(bannerView.size, RUNABannerViewSizeDefault);

    [self execute:expectation delayTime:1.0 targetMethod:^{
        [bannerView setSize:RUNABannerViewSizeAspectFit];
    } assertionBlock:^{
        XCTAssertEqual(bannerView.size, RUNABannerViewSizeAspectFit);
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testSetPosition {
    RUNABannerView *bannerView = [RUNABannerView new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];
    
    XCTAssertEqual(bannerView.position, RUNABannerViewPositionCustom);

    [self execute:expectation delayTime:1.0 targetMethod:^{
        [bannerView setPosition:RUNABannerViewPositionTop];
    } assertionBlock:^{
        XCTAssertEqual(bannerView.position, RUNABannerViewPositionTop);
    }];
    
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testApplyIntegration {
    MainViewController *viewController = [MainViewController new];
    [viewController loadViewIfNeeded];
    
    RUNABannerView *bannerView = viewController.bannerView;
    bannerView.adSpotId = kValidAdspotId;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];
    expectation.expectedFulfillmentCount = 2;
    
    [self execute:expectation delayTime:7.0 targetMethod:^{
        bannerView.size = RUNABannerViewSizeAspectFit;
        bannerView.position = RUNABannerViewPositionTop;
        [bannerView load];
    } assertionBlock:^{
        XCTAssertEqual(bannerView.sizeConstraints.count, (NSUInteger)2);
        XCTAssertEqual(bannerView.positionConstraints.count, (NSUInteger)2);
        XCTAssertFalse(bannerView.translatesAutoresizingMaskIntoConstraints);
        // Custom Params Test
        bannerView.size = RUNABannerViewSizeCustom;
        bannerView.position = RUNABannerViewPositionCustom;
        [bannerView load];
    }];
    
    [self execute:expectation delayTime:12.0 targetMethod:^{
    } assertionBlock:^{
        XCTAssertNil(bannerView.sizeConstraints);
        XCTAssertNil(bannerView.positionConstraints);
        XCTAssertFalse(bannerView.translatesAutoresizingMaskIntoConstraints);
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

# pragma mark - Response Tests

- (void)testParse {
    // TODO: Create dummy BidResponse
}

- (void)testIsFinished {
    RUNABannerView *bannerView = [RUNABannerView new];
    XCTAssertFalse([bannerView isFinished]);
    bannerView.state = RUNA_ADVIEW_STATE_LOADING;
    XCTAssertFalse([bannerView isFinished]);
    bannerView.state = RUNA_ADVIEW_STATE_LOADED;
    XCTAssertFalse([bannerView isFinished]);
    bannerView.state = RUNA_ADVIEW_STATE_FAILED;
    XCTAssertTrue([bannerView isFinished]);
    bannerView.state = RUNA_ADVIEW_STATE_RENDERING;
    XCTAssertFalse([bannerView isFinished]);
    bannerView.state = RUNA_ADVIEW_STATE_MESSAGE_LISTENING;
    XCTAssertFalse([bannerView isFinished]);
    bannerView.state = RUNA_ADVIEW_STATE_SHOWED;
    XCTAssertTrue([bannerView isFinished]);
    bannerView.state = RUNA_ADVIEW_STATE_CLICKED;
    XCTAssertFalse([bannerView isFinished]);
}

- (void)testTriggerSuccess {
    RUNABannerView *bannerView = [RUNABannerView new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];

    [self execute:expectation delayTime:3.0 targetMethod:^{
        bannerView.eventHandler = ^(RUNABannerView * _Nonnull view, struct RUNABannerViewEvent event) {
            XCTAssertEqual(event.eventType, RUNABannerViewEventTypeSucceeded);
        };
        [bannerView triggerSuccess];
    } assertionBlock:^{
        // TODO: advertiseId test
        XCTAssertEqual(bannerView.state, RUNA_ADVIEW_STATE_SHOWED);
        XCTAssertFalse(bannerView.hidden);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testTriggerFailure {
    RUNABannerView *bannerView = [RUNABannerView new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];

    [self execute:expectation delayTime:3.0 targetMethod:^{
        bannerView.eventHandler = ^(RUNABannerView * _Nonnull view, struct RUNABannerViewEvent event) {
            XCTAssertEqual(event.eventType, RUNABannerViewEventTypeFailed);
        };
        [bannerView triggerFailure];
    } assertionBlock:^{
        XCTAssertEqual(bannerView.state, RUNA_ADVIEW_STATE_FAILED);
        XCTAssertTrue(bannerView.hidden);
        XCTAssertNil(bannerView.webView.navigationDelegate);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

# pragma mark - Video Tests

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

#pragma mark - Helper Method

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
