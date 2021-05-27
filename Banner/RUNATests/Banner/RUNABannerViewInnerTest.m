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
@property (nonatomic) RUNAMediaType mediaType;
- (void)setInitState;
- (void)applyAdView;
- (void)playVideo;
- (void)pauseVideo;
@end

@interface RUNABannerViewInnerTest : XCTestCase
@end

@implementation RUNABannerViewInnerTest

- (void)testScriptMessageEvent {
    // Case: video_loaded
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];
    RUNABannerView *actual = [[RUNABannerView alloc]initWithEventType:@"video_loaded"];
    
    [self execute:expectation delayTime:1.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.videoState, RUNA_VIDEO_STATE_LOADED);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testMediaType {
    RUNABannerView *actual = [RUNABannerView new];
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];
    expectation.expectedFulfillmentCount = 3;
    
    // Case: TypeUnknown
    [self execute:expectation delayTime:1.0 targetMethod:^{
        [actual setInitState];
    } assertionBlock:^{
        XCTAssertEqual(actual.mediaType, RUNA_MEDIA_TYPE_UNKOWN);
    }];
    
    // Case: TypeBanner
    actual = [[RUNABannerView alloc]initWithEventType:@"expand"];
    [self execute:expectation delayTime:1.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.mediaType, RUNA_MEDIA_TYPE_BANNER);
    }];
    
    // Case: TypeVideo
    actual = [[RUNABannerView alloc]initWithEventType:@"video"];
    [self execute:expectation delayTime:1.0 targetMethod:^{
        [actual applyAdView];
    } assertionBlock:^{
        XCTAssertEqual(actual.mediaType, RUNA_MEDIA_TYPE_VIDEO);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testEvaluateJavaScript {
    RUNABannerView *actual = [[RUNABannerView alloc]initWithEventType:@"video_loaded"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"desc"];
    expectation.expectedFulfillmentCount = 3;
    
    // Case: InitialStatus
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
