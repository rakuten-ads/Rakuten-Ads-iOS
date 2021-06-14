//
//  RUNABannerViewMeasurableTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/05/20.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNABannerViewInner.h"
#import "MainViewController.h"

@interface RUNABannerView (Spy)
- (BOOL)measureInview;
- (BOOL)sendMeasureImp;
- (BOOL)measureImp;
- (float)getVisibility:(UIWindow *)window
    rootViewController:(UIViewController *)rootViewController;
- (BOOL)isVisible:(float)visibility;
@end

@interface RUNABannerViewMeasurableTest : XCTestCase
@property (nonatomic) MainViewController *viewController;
@property (nonatomic) UIWindow *dummyWindow;
@property (nonatomic) RUNABannerView *bannerView;
@end

@implementation RUNABannerViewMeasurableTest

@synthesize viewController = _viewController;
@synthesize dummyWindow = _dummyWindow;

- (void)setUp {
    self.dummyWindow = [[UIWindow alloc] initWithFrame:self.viewController.view.frame];
    self.viewController = [MainViewController new];
    [self.viewController loadViewIfNeeded];
    [super setUp];
}

- (void)testMeasureInview {
    // Case: banner.inviewURL is nil
    RUNABannerView *bannerView = [RUNABannerView new];
    XCTAssertTrue([bannerView measureInview]);
}

- (void)testSendMeasureImp {
    // Case: banner.inviewURL is nil
    RUNABannerView *bannerView = [RUNABannerView new];
    XCTAssertTrue([bannerView sendMeasureImp]);
}

- (void)testMeasureImp {
    // Case: banner.measuredURL is nil
    RUNABannerView *bannerView = [RUNABannerView new];
    XCTAssertTrue([bannerView measureImp]);
}

- (void)testIsVisible {
    self.bannerView = self.viewController.bannerView;
    // Hidden banner
    XCTAssertFalse([self isVisible]);
    // Not hidden banner
    self.bannerView.hidden = NO;
    XCTAssertTrue([self isVisible]);
    // Outview: default
    self.bannerView.frame = CGRectMake(0, kBannerHeight * -1, kBannerWidth, kBannerHeight);
    XCTAssertFalse([self isVisible]);
    // Outview: threshold
    self.bannerView.frame = CGRectMake(0, kBannerHeight * -0.5, kBannerWidth, kBannerHeight);
    XCTAssertFalse([self isVisible]);
}

#pragma mark - Helper Method

- (BOOL)isVisible {
    float visibility = [self.bannerView getVisibility:self.dummyWindow rootViewController:self.viewController];
    return [self.bannerView isVisible:visibility];
}

@end
