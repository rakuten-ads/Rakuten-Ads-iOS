//
//  RUNAViewabilityProviderTests.m
//  BannerTests
//
//  Created by Wu, Wei | David on 2022/02/16.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAViewabilityProvider.h"
#import "RUNAMeasurement.h"
#import <RUNACore/RUNAUIView+.h>


@interface RUNAViewabilityProvider(Tests)

@property(nonatomic) NSMutableDictionary<NSString*, RUNAMeasurableTarget*>* targetDict;

@end

@interface RUNAMeasurableTarget(Tests)

@property(nonatomic, nullable) RUNAMeasurementConfiguration* defaultMeasurementConfig;
-(float)getVisibility:(UIWindow *)window rootViewController:(UIViewController *)rootViewController;
-(BOOL)isVisible:(float)visibility;

@end


@interface RUNAViewabilityProviderTests : XCTestCase

@end

FOUNDATION_EXPORT NSString* kRUNAMeasurerDefault;

@implementation RUNAViewabilityProviderTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testTargetViewInvisible {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    RUNAViewabilityProvider* provider = [RUNAViewabilityProvider sharedInstance];

    // register nil
    [provider registerTargetView:nil withViewImpURL:nil completionHandler:nil];
    XCTAssertEqual(provider.targetDict.count, 0);

    [provider registerTarget:nil];
    XCTAssertEqual(provider.targetDict.count, 0);

    // register a view
    UIView* targetView = [UIView new];
    [provider registerTargetView:targetView withViewImpURL:nil completionHandler:nil];

    XCTAssertEqual(provider.targetDict.count, 1);
    NSString* key = targetView.runaViewIdentifier;
    RUNAMeasurableTarget* target = provider.targetDict[key];
    XCTAssertNotNil(target);
    XCTAssertTrue([key isEqualToString:target.identifier]);
    XCTAssertEqual(target.view, targetView);
    XCTAssertNil(target.defaultMeasurementConfig.viewImpURL);
    XCTAssertNil(target.defaultMeasurementConfig.completionHandler);
    XCTAssertTrue([target.measurers[kRUNAMeasurerDefault] isKindOfClass: RUNADefaultMeasurer.class]);

    // unregister nil
    XCTAssertNoThrow([provider unregisterTargetView:nil]);

    // unregister view
    XCTAssertNoThrow([provider unregisterTargetView:targetView]);
    XCTAssertNil([provider.targetDict valueForKey:key]);

    XCTAssertNoThrow([provider unregisterTarget:nil]);
    XCTAssertEqual(provider.targetDict.count, 0);
}

-(void)testTargetViewVisible {

    RUNAViewabilityProvider* provider = [RUNAViewabilityProvider sharedInstance];
    XCTestExpectation *expectation = [self expectationWithDescription:@"viewable detect completion handler"];

    UIView* targetView = [UIView new];
    [provider registerTargetView:targetView withViewImpURL:@"https://www.rakuten.com" completionHandler:^(UIView * _Nonnull view) {
        NSLog(@"view visible");
        [expectation fulfill];
    }];

    XCTAssertEqual(provider.targetDict.count, 1);
    NSString* key = targetView.runaViewIdentifier;
    RUNAMeasurableTarget* target = provider.targetDict[key];
    XCTAssertNotNil(target);

    XCTAssertNotNil(target.measurers[kRUNAMeasurerDefault]);
    XCTAssertFalse([target measureInview]);
    XCTAssertTrue([target didMeasureInview:YES]); [self waitForExpectationsWithTimeout:5.0 handler:nil];
    XCTAssertFalse([target didMeasureInview:NO]);

    XCTAssertTrue([target getVisibility:[UIWindow new] rootViewController:[UIViewController new]] == 0);
    XCTAssertTrue([target isVisible:0.6]);
    XCTAssertFalse([target isVisible:0.5]);

    XCTAssertNoThrow([provider unregsiterTargetView:targetView]);
    XCTAssertNil([provider.targetDict valueForKey:key]);

}
@end
