//
//  RUNABannerViewMeasurableTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/05/20.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNABannerView.h"

@interface RUNABannerViewMeasurableTest : XCTestCase

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) RUNABannerView *bannerView;

@end

@implementation RUNABannerViewMeasurableTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
