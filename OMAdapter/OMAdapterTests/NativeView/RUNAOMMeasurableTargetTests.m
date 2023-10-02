//
//  RUNAOMNativeMeasurableTargetTests.m
//  OMAdapterTests
//
//  Created by Wu, Wei | David | GATD on 2023/07/25.
//  Copyright © 2023 RUNA. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAOMNativeMeasurableTarget.h"
#import "RUNAOMNativeMeasurer.h"

@interface RUNAOMNativeMeasurableTargetTests : XCTestCase

@property(nonatomic) UIView* targetView;

@end

FOUNDATION_EXPORT NSString* kRUNAMeasurerOM;

@implementation RUNAOMNativeMeasurableTargetTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.targetView = [UIView new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_setRUNAOMConfiguration {

    RUNAOMNativeProviderConfiguration* config = [RUNAOMNativeProviderConfiguration new];

    RUNAMeasurableTarget* target = [[RUNAMeasurableTarget alloc] initWithView:self.targetView];
    [target setRUNAOMNativeConfiguration:config];
    XCTAssertEqual(target.measurers.count, 0);

    [target setRUNAOMNativeConfiguration:nil];
    XCTAssertEqual(target.measurers.count, 0);

    [target setRUNAOMNativeConfiguration:config];
    XCTAssertEqual(target.measurers.count, 0);

    config.verificationJsURL = @"varify.js";
    [target setRUNAOMNativeConfiguration:config];
    XCTAssertEqual(target.measurers.count, 0);

    config.vendorKey = @"key";
    [target setRUNAOMNativeConfiguration:config];
    XCTAssertEqual(target.measurers.count, 0);

    config.vendorParameters = @"param";
    [target setRUNAOMNativeConfiguration:config];
    XCTAssertEqual(target.measurers.count, 1);

    id<RUNAMeasurer> measurer = target.measurers[kRUNAMeasurerOM];
    XCTAssertTrue([measurer isKindOfClass:RUNAOMNativeMeasurer.class]);
    XCTAssertEqualObjects(((RUNAOMNativeMeasurer*)measurer).configuration.vendorKey, config.vendorKey);
    XCTAssertEqualObjects(((RUNAOMNativeMeasurer*)measurer).configuration.vendorParameters, config.vendorParameters);
    XCTAssertEqualObjects(((RUNAOMNativeMeasurer*)measurer).configuration.verificationJsURL, config.verificationJsURL);
    XCTAssertEqualObjects(((RUNAOMNativeMeasurer*)measurer).configuration.providerURL, RUNAOMNativeProviderConfiguration.defaultConfiguration.providerURL);

}

- (void)test_RUNAOpenMeasurement {
    RUNAMeasurableTarget* target = [[RUNAMeasurableTarget alloc] initWithView:self.targetView];
    XCTAssertEqualObjects(target.getOMAdView, self.targetView);
    XCTAssertEqualObjects(target.getOMWebView, nil);
    XCTAssertEqualObjects([target injectOMProvider:@"provider.js" IntoHTML:@"<html>"], @"<html>");
    XCTAssertNil([target getOpenMeasurer]);
    [target setRUNAOMNativeConfiguration:RUNAOMNativeProviderConfiguration.defaultConfiguration];
    XCTAssertEqualObjects([target getOpenMeasurer], target.measurers[kRUNAMeasurerOM]);
}

@end
