//
//  RUNABannerCarouselViewTests.m
//  BannerTests
//
//  Created by Wu, Wei | David on 2022/02/14.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNATests+Extension.h"
#import "RUNABannerViewExtension.h"
#import "RUNABannerCarouselViewinner.h"
#import "RUNABannerCarouselViewExtension.h"

@interface RUNABannerCarouselView(Tests)

@property(nonatomic) CGFloat maxAspectRatio;

-(void) adjustMaxHeightByContentSize:(CGSize) size;
- (CGFloat)calculateCellWidth:(UICollectionView * _Nonnull)collectionView;
- (CGFloat)calculateCellHeight:(CGFloat)cellWidth;

@end

@interface RUNABannerCarouselViewTests : XCTestCase

@end

@implementation RUNABannerCarouselViewTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCarouselViewLoadWithAdspotIds {
    RUNABannerCarouselView* view = [RUNABannerCarouselView new];
    XCTAssertThrows([view load]);

    view.adSpotIds = @[@"995", @"996", @"997"];
    view.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    view.itemEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    view.itemWidth = 200;
    view.itemSpacing = 15;
    view.minItemOverhangWidth = 80;
    view.itemScaleMode = RUNABannerCarouselViewItemScaleFixedWidth;
    [view setRp:@"rpCookie"];
    [view setRz:@"rzCookie"];
    XCTAssertNoThrow([view description]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"CarouselViewLoad"];

    UIViewController* viewCtrl = [UIViewController new];
    [viewCtrl.view addSubview:view];
    [NSLayoutConstraint activateConstraints:@[
        [view.topAnchor constraintEqualToAnchor:viewCtrl.view.safeAreaLayoutGuide.topAnchor],
        [view.leadingAnchor constraintEqualToAnchor:viewCtrl.view.safeAreaLayoutGuide.leadingAnchor],
    ]];
    [viewCtrl loadViewIfNeeded];
    XCTAssertNoThrow([view loadWithEventHandler:^(RUNABannerCarouselView * _Nonnull view, RUNABannerView * _Nullable banner, struct RUNABannerViewEvent event) {
        XCTAssertNotNil(view);
        if (event.eventType == RUNABannerViewEventTypeGroupFinished
            || event.eventType == RUNABannerViewEventTypeGroupFailed) {
            XCTAssertEqual(view.itemCount, 3);
            [expectation fulfill];
        } else {
            XCTAssertNotNil(banner);
        }
    }]);

    NSLog(@"%@", view);

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testCarouselViewLoadWithBannerItemViews {
    RUNABannerCarouselView* view = [RUNABannerCarouselView new];
    NSMutableArray<RUNABannerView*>* banners = [NSMutableArray array];
    for (NSString* adspotId in @[@"995", @"996", @"997"]) {
        RUNABannerView* banner = [RUNABannerView new];
        banner.adSpotId = adspotId;
        banner.size = RUNABannerViewSizeCustom;
        [banner setCustomTargeting:@{@"category" : @"unit test"}];
        RUNABannerViewGenreProperty* genre = [[RUNABannerViewGenreProperty alloc] initWithMasterId:1 code:@"test" match:@"carouselView"];
        [banner setPropertyGenre:genre];
        [banners addObject:banner];
    }

    view.itemViews = banners;
    view.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    view.itemEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    view.itemWidth = 200;
    view.itemSpacing = 15;
    view.minItemOverhangWidth = 80;
    view.itemScaleMode = RUNABannerCarouselViewItemScaleFixedWidth;
    [view setRp:@"rpCookie"];
    [view setRz:@"rzCookie"];
    [view setRpoint:30];
    [view setRpoint:-30];
    [view setEasyId:@"easyid"];

    XCTestExpectation *expectation = [self expectationWithDescription:@"CarouselViewLoad"];

    [self syncExecute:expectation delayTime:1.0 targetMethod:^{
        UIViewController* viewCtrl = [UIViewController new];
        [viewCtrl.view addSubview:view];
        [NSLayoutConstraint activateConstraints:@[
            [view.topAnchor constraintEqualToAnchor:viewCtrl.view.safeAreaLayoutGuide.topAnchor],
            [view.leadingAnchor constraintEqualToAnchor:viewCtrl.view.safeAreaLayoutGuide.leadingAnchor],
        ]];
        [viewCtrl loadViewIfNeeded];
        XCTAssertNoThrow([view loadWithEventHandler:^(RUNABannerCarouselView * _Nonnull view, RUNABannerView * _Nullable banner, struct RUNABannerViewEvent event) {
            XCTAssertNotNil(view);
            if (event.eventType != RUNABannerViewEventTypeFailed
                && event.eventType != RUNABannerViewEventTypeGroupFailed) {
                XCTAssertNotNil(banner);
            }
        }]);
    } assertionBlock:^{
        XCTAssertEqual(view.itemViews.firstObject.size, RUNABannerViewSizeAspectFit);
        XCTAssertEqual(view.group.banners.count, banners.count);
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAdjustMaxHeightByContentSize {
    RUNABannerCarouselView* view = [RUNABannerCarouselView new];

    [view adjustMaxHeightByContentSize:CGSizeMake(300, 100)];
}

- (void)testCalculateCellWidth {
    RUNABannerCarouselView* carouselView = [RUNABannerCarouselView new];
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.frame = CGRectMake(0, 0, 400, 200);

    carouselView.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 20, 30);
    carouselView.itemSpacing = 5;

    CGFloat w1 = [carouselView calculateCellWidth:collectionView];

    XCTAssertEqual(w1, 400 - 20 - 5 - 30);

    carouselView.itemScaleMode = RUNABannerCarouselViewItemScaleFixedWidth;
    carouselView.itemWidth = 125;
    CGFloat w2 = [carouselView calculateCellWidth:collectionView];
    XCTAssertEqual(w2, 125);

}

-(void) testCalculateCellHeight {
    RUNABannerCarouselView* carouselView = [RUNABannerCarouselView new];
    carouselView.itemEdgeInsets = UIEdgeInsetsMake(10, 20, 20, 30);

    carouselView.maxAspectRatio = 0.5;
    XCTAssertEqual([carouselView calculateCellHeight:200], (200 - 20 - 30) * 0.5 + 10 + 20);
}

@end
