//
//  RUNABannerViewMeasurableTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/05/20.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNABannerViewInner.h"

const CGFloat kBannerHeight = 50.f;
const CGFloat kBannerWidth = 200.f;

@interface RUNABannerView (Spy)
- (BOOL)measureInview;
- (BOOL)sendMeasureImp;
- (BOOL)measureImp;
- (float)getVisibility:(UIWindow *)window
    rootViewController:(UIViewController *)rootViewController;
- (BOOL)isVisible:(float)visibility;
@end

@interface RUNABannerViewMeasurableTest : XCTestCase
@property (nonatomic) UIViewController *viewController;
@property (nonatomic) UIWindow *dummyWindow;
@property (nonatomic) RUNABannerView *bannerView;
@end

@implementation RUNABannerViewMeasurableTest

@synthesize viewController = _viewController;
@synthesize dummyWindow = _dummyWindow;

- (void)setUp {
    // UIViewController
    CGRect iPhone12ScreenFrame = CGRectMake(0, 0, 390, 844);
    self.viewController = [[UIViewController alloc]init];
    self.viewController.view.frame = iPhone12ScreenFrame;
    // Banner
    self.bannerView = [[RUNABannerView alloc]initWithFrame:CGRectMake(0, 0, kBannerWidth, kBannerHeight)];
    [self.viewController.view addSubview:self.bannerView];
    // Window
    self.dummyWindow = [[UIWindow alloc] initWithFrame:iPhone12ScreenFrame];
    
    [self.viewController loadViewIfNeeded];
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
