//
//  RUNABannerViewInnerTests.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/05/25.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNATests+Extension.h"
#import "RUNABannerView+Mock.h"
#import "RUNABannerViewInner.h"

NSString *const kDummyAdspotId = @"99999";
NSString *const kDummyAdspotCode = @"code99999";

@interface RUNABannerView (Spy)
@property (nonatomic) RUNABanner *banner;
@property (nonatomic) RUNABannerViewState state;
@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* sizeConstraints;
@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* positionConstraints;
@property (nonatomic, readonly) RUNABannerViewError error;
@property (nonatomic, readonly) RUNAVideoState videoState;
@property (nonatomic) RUNAMediaType mediaType;
- (void)setInitState;
- (BOOL)isLoading;
- (void)applyAdView;
- (void)applyPositionWithParentView;
- (void)onBidResponseFailed:(nonnull NSHTTPURLResponse *)response error:(nullable NSError *)error;
- (void)onBidResponseSuccess:(nonnull NSArray<RUNABanner*> *)adInfoList withSessionId:(nonnull NSString *)sessionId;
- (BOOL)isFinished;
- (void)triggerSuccess;
- (void)triggerFailure;
- (void)playVideo;
- (void)pauseVideo;
@end

@interface RUNABannerViewInnerTests : XCTestCase
@end

@implementation RUNABannerViewInnerTests

- (void)testIntialize {
    RUNABannerView *bannerView = [[RUNABannerView alloc]initWithFrame:CGRectZero];
    XCTAssertNotNil(bannerView.imp);
    XCTAssertNil(bannerView.imp.banner);
    XCTAssertNil(bannerView.userId);
    XCTAssertNil(bannerView.userExt);
    XCTAssertNotNil(bannerView.imp.json);
    XCTAssertEqual(bannerView.imp.json.allKeys.count, (NSUInteger)0);
    XCTAssertFalse(bannerView.disableBorderAdjustment);
    // Initial State
    XCTAssertTrue(bannerView.hidden);
    XCTAssertEqual(bannerView.state, RUNA_ADVIEW_STATE_INIT);
    XCTAssertEqual(bannerView.error, RUNABannerViewErrorNone);
    XCTAssertEqual(bannerView.videoState, RUNA_VIDEO_STATE_UNKNOWN);
    XCTAssertEqual(bannerView.mediaType, RUNA_MEDIA_TYPE_BANNER);
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
}

// Test to confirm the passage of method for coverage
- (void)testLoadAdSpotId {
    RUNABannerView *bannerView = [RUNABannerView new];
    bannerView.adSpotId = kDummyAdspotId;
    {
        XCTAssertNoThrow([bannerView load]);
    }
    {
        XCTAssertNoThrow([bannerView loadWithEventHandler:^(RUNABannerView * _Nonnull view, struct RUNABannerViewEvent event) {
            XCTAssertEqual(event.eventType, RUNABannerViewEventTypeFailed);
            XCTAssertEqual(event.error, RUNABannerViewErrorUnfilled);
            XCTAssertEqual(bannerView.state, RUNA_ADVIEW_STATE_FAILED);
        }]);
    }
}

- (void)testLoadAdSpotCode {
    RUNABannerView *bannerView = [RUNABannerView new];
    bannerView.adSpotCode = kDummyAdspotCode;
    {
        XCTAssertNoThrow([bannerView load]);
    }
    {
        XCTAssertNoThrow([bannerView loadWithEventHandler:^(RUNABannerView * _Nonnull view, struct RUNABannerViewEvent event) {
            XCTAssertEqual(event.eventType, RUNABannerViewEventTypeFailed);
            XCTAssertEqual(event.error, RUNABannerViewErrorUnfilled);
            XCTAssertEqual(bannerView.state, RUNA_ADVIEW_STATE_FAILED);
        }]);
    }
}

-(void)testLoadWithEmptyAdSpotIdAndAdSpotCode {
    XCTestExpectation *expectation = [self expectationWithDescription:@"async load test"];
    RUNABannerView *bannerView = [RUNABannerView new];
    [bannerView loadWithEventHandler:^(RUNABannerView * _Nonnull view, struct RUNABannerViewEvent event) {
        XCTAssertEqual(event.eventType, RUNABannerViewEventTypeFailed);
        XCTAssertEqual(event.error, RUNABannerViewErrorFatal);
        XCTAssertEqual(view.state, RUNA_ADVIEW_STATE_FAILED);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testSetSize {
    NSArray *params = @[@(RUNABannerViewSizeAspectFit),
                        @(RUNABannerViewSizeCustom),
                        @(RUNABannerViewSizeDefault)];
    
    RUNABannerView *bannerView = [self getBannerViewOnViewController];
    bannerView.state = RUNA_ADVIEW_STATE_SHOWED; // mock state
    bannerView.disableBorderAdjustment = YES;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"setSize"];
    expectation.expectedFulfillmentCount = params.count;
    
    XCTAssertEqual(bannerView.size, RUNABannerViewSizeDefault); // default value
    
    [params enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger idx, BOOL *stop) {
        RUNABannerViewSize size = [value integerValue];
        
        [self syncExecute:expectation delayTime:1.0 targetMethod:^{
            [bannerView setSize:size];
        } assertionBlock:^{
            XCTAssertEqual(bannerView.size, size);
            if (size == RUNABannerViewSizeCustom) {
                XCTAssertNil(bannerView.sizeConstraints);
            } else {
                XCTAssertEqual(bannerView.sizeConstraints.count, (NSUInteger)2);
                XCTAssertFalse(bannerView.translatesAutoresizingMaskIntoConstraints);
            }
        }];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testSetPosition {
    NSArray *params = @[@(RUNABannerViewPositionTop),
                        @(RUNABannerViewPositionBottom),
                        @(RUNABannerViewPositionTopLeft),
                        @(RUNABannerViewPositionTopRight),
                        @(RUNABannerViewPositionBottomLeft),
                        @(RUNABannerViewPositionBottomRight),
                        @(RUNABannerViewPositionCustom)];
    
    RUNABannerView *bannerView = [self getBannerViewOnViewController];
    bannerView.state = RUNA_ADVIEW_STATE_SHOWED; // mock state
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"setPosition"];
    expectation.expectedFulfillmentCount = params.count;
    
    XCTAssertEqual(bannerView.position, RUNABannerViewPositionCustom); // default value
    
    [params enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger idx, BOOL *stop) {
        RUNABannerViewPosition position = [value integerValue];
        
        [self syncExecute:expectation delayTime:1.0 targetMethod:^{
            [bannerView setPosition:position];
        } assertionBlock:^{
            XCTAssertEqual(bannerView.position, position);
            if (position == RUNABannerViewPositionCustom) {
                XCTAssertNil(bannerView.positionConstraints);
            } else {
                XCTAssertEqual(bannerView.positionConstraints.count, (NSUInteger)2);
                XCTAssertFalse(bannerView.translatesAutoresizingMaskIntoConstraints);
            }
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testSetProperties {
    RUNABannerView* bannerView = [RUNABannerView new];
    bannerView.properties = @{
        @"env" : @"test"
    };
    XCTAssertEqual(bannerView.imp.json[@"env"], @"test");
}

/**
- (void)testApplyPositionWithParentView {
    RUNABannerView *bannerView = [self getBannerViewOnViewController];
    
    NSArray *params = @[@(RUNABannerViewPositionTop),
                        @(RUNABannerViewPositionBottom),
                        @(RUNABannerViewPositionTopLeft),
                        @(RUNABannerViewPositionTopRight),
                        @(RUNABannerViewPositionBottomLeft),
                        @(RUNABannerViewPositionBottomRight),
                        @(RUNABannerViewPositionCustom)];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"setPosition"];
    expectation.expectedFulfillmentCount = params.count;
    
    XCTAssertEqual(bannerView.position, RUNABannerViewPositionCustom); // default value
    
    [params enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger idx, BOOL *stop) {
        RUNABannerViewPosition position = [value integerValue];
        [self syncExecute:expectation delayTime:1.0 targetMethod:^{
            [bannerView setPosition:position];
            [bannerView applyPositionWithParentView];
        } assertionBlock:^{
            XCTAssertEqual(bannerView.position, position);
            if (position == RUNABannerViewPositionCustom) {
                XCTAssertNil(bannerView.positionConstraints);
            } else {
                XCTAssertEqual(bannerView.positionConstraints.count, (NSUInteger)2);
            }
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}
*/

// Test to confirm the passage of method for coverage
- (void)testSendRemoteLogWithMessage {
    RUNABannerView *bannerView = [RUNABannerView new];
    XCTAssertNoThrow([bannerView sendRemoteLogWithMessage:@"message" andException:[NSException exceptionWithName:@"name" reason:@"reason" userInfo:@{@"kye":@"value"}]]);
}

# pragma mark - Response Tests

- (void)testOnBidResponseFailed {
    RUNABannerView *bannerView = [RUNABannerView new];
    NSURL *url = [[NSURL alloc]initWithString:@"dummyUrl"];
    {
        // Case: Unfilled
        XCTestExpectation *expectation = [self expectationWithDescription:@"onBidResponseFailed"];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            NSHTTPURLResponse *mockResponse = [[NSHTTPURLResponse alloc]initWithURL:url statusCode:kRUNABidResponseUnfilled HTTPVersion:nil headerFields:nil];
            [bannerView onBidResponseFailed:mockResponse error:nil];
        } assertionBlock:^{
            XCTAssertEqual(bannerView.error, RUNABannerViewErrorUnfilled);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
    {
        // Case: Error
        XCTestExpectation *expectation = [self expectationWithDescription:@"onBidResponseFailed"];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            NSHTTPURLResponse *mockResponse = [[NSHTTPURLResponse alloc]initWithURL:url statusCode:400 HTTPVersion:nil headerFields:nil];
            NSError *error = [NSError errorWithDomain:@"dummyDomain" code:400 userInfo:@{}];
            [bannerView onBidResponseFailed:mockResponse error:error];
        } assertionBlock:^{
            XCTAssertEqual(bannerView.error, RUNABannerViewErrorNetwork);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
}

- (void)testOnBidResponseSuccess {
    {
        // Case: Default
        RUNABannerView *bannerView = [[RUNABannerView alloc]initWithBidData];
        XCTestExpectation *expectation = [self expectationWithDescription:@"onBidResponseSuccess"];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            [bannerView onBidResponseSuccess:@[bannerView.banner] withSessionId:@"sessionId"];
        } assertionBlock:^{
            //XCTAssertEqual(group.state, RUNA_ADVIEW_STATE_LOADED);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
    {
        // Case: Exception
        RUNABannerView *bannerView = [RUNABannerView new];
        XCTestExpectation *expectation = [self expectationWithDescription:@"onBidResponseSuccess"];
        [self execute:expectation delayTime:3.0 targetMethod:^{
            [bannerView onBidResponseSuccess:@[[RUNABanner new]] withSessionId:@"dummyId"];
        } assertionBlock:^{
            XCTAssertEqual(bannerView.state, RUNA_ADVIEW_STATE_FAILED);
            XCTAssertEqual(bannerView.error, RUNABannerViewErrorInternal);
        }];
        [self waitForExpectationsWithTimeout:5.0 handler:nil];
    }
}

- (void)testParse {
    RUNABannerView *bannerView = [RUNABannerView new];
    RUNABanner *banner = [bannerView parse:[RUNABannerView dummyBidData]];
    XCTAssertNotNil(banner);
    XCTAssertNotNil(banner.impId);
    XCTAssertNotNil(banner.html);
    XCTAssertEqual(banner.width, 1280.f);
    XCTAssertEqual(banner.height, 720.f);
    XCTAssertNotNil(banner.measuredURL);
    XCTAssertNotNil(banner.inviewURL);
    XCTAssertNotNil(banner.viewabilityProviderURL);
    XCTAssertNotEqual(banner.advertiseId, (NSInteger)480);
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


// Set a longer waiting time due to concerns about the specifications of the virtual environment
- (void)testScriptMessageEvent {
    RUNABannerView *actual;
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];
    expectation.expectedFulfillmentCount = 6;

    // Case: expand
    actual = [[RUNABannerView alloc]initWithEventType:@"expand"];
    [self execute:expectation delayTime:3.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.mediaType, RUNA_MEDIA_TYPE_BANNER);
        XCTAssertEqual(actual.state, RUNA_ADVIEW_STATE_SHOWED);
    }];
    // Case: collapse
    actual = [[RUNABannerView alloc]initWithEventType:@"collapse"];
    [self execute:expectation delayTime:3.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.state, RUNA_ADVIEW_STATE_FAILED);
    }];
    // Case: register
    actual = [[RUNABannerView alloc]initWithEventType:@"register"];
    [self execute:expectation delayTime:3.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.state, RUNA_ADVIEW_STATE_MESSAGE_LISTENING);
    }];
    // Case: unfilled
    actual = [[RUNABannerView alloc]initWithEventType:@"unfilled"];
    [self execute:expectation delayTime:3.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.error, RUNABannerViewErrorUnfilled);
        XCTAssertEqual(actual.state, RUNA_ADVIEW_STATE_FAILED);
    }];
    // Case: video
    actual = [[RUNABannerView alloc]initWithEventType:@"video"];
    [self execute:expectation delayTime:3.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.mediaType, RUNA_MEDIA_TYPE_VIDEO);
    }];
    // Case: video_loaded
    actual = [[RUNABannerView alloc]initWithEventType:@"video_loaded"];
    [self execute:expectation delayTime:3.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.videoState, RUNA_VIDEO_STATE_LOADED);
    }];

    [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testEvaluateJavaScript {
    RUNABannerView *actual = [[RUNABannerView alloc]initWithEventType:@"video_loaded"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];
    expectation.expectedFulfillmentCount = 3;

    // Case: InitialStatus
    XCTAssertEqual(actual.mediaType, RUNA_MEDIA_TYPE_BANNER);
    XCTAssertEqual(actual.videoState, RUNA_VIDEO_STATE_UNKNOWN);

    // Case: PlayVideo
    [self execute:expectation delayTime:3.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.videoState, RUNA_VIDEO_STATE_LOADED);
        [actual playVideo];
    }];
    [self execute:expectation delayTime:7.0 targetMethod:^{
    } assertionBlock:^{
        XCTAssertEqual(actual.videoState, RUNA_VIDEO_STATE_PLAYING);
        [actual pauseVideo];
    }];

    // Case: PauseVideo
    [self execute:expectation delayTime:10.0 targetMethod:^{
    } assertionBlock:^{
        XCTAssertEqual(actual.videoState, RUNA_VIDEO_STATE_PAUSED);
    }];

    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

#pragma mark - Helper Method

- (RUNABannerView*)getBannerViewOnViewController {
    UIViewController *viewController = [UIViewController new];
    RUNABannerView *bannerView = [[RUNABannerView alloc]initWithBidData];
    bannerView.frame = CGRectMake(0, 0, 200, 50);
    [viewController.view addSubview:bannerView];
    [viewController loadViewIfNeeded];
    return bannerView;
}

@end
