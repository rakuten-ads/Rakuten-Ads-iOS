//
//  RUNABannerViewMeasurableTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/05/20.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAMeasurement.h"
#import "MainViewController.h"

@interface RUNABannerView (PrivateMethod)
- (float)getVisibility:(UIWindow *)window
    rootViewController:(UIViewController *)rootViewController;
- (BOOL)isVisible:(float)visibility;
@end

@interface RUNABannerViewMeasurableTest : XCTestCase
@property (nonatomic) MainViewController *viewController;
@property (nonatomic) UIWindow *window;
@property (nonatomic) RUNABannerView *bannerView;
@end

@implementation RUNABannerViewMeasurableTest

@synthesize viewController = _viewController;
@synthesize window = _window;

- (void)setUp {
    self.window = [[UIWindow alloc] initWithFrame:self.viewController.view.frame];
    self.viewController = [MainViewController new];
    [super setUp];
}

- (void)testMeasureInview {
    [self.viewController loadViewIfNeeded];
    self.bannerView = self.viewController.bannerView;
    // TODO: load method to spy method
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

- (BOOL)isVisible {
    float visibility = [self.bannerView getVisibility:self.window rootViewController:self.viewController];
    return [self.bannerView isVisible:visibility];
}

@end
