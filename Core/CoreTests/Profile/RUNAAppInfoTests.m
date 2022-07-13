//
//  RUNAAppInfoTests.m
//  CoreTests
//
//  Created by Wu, Wei | David on 2022/07/12.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAAppInfo.h"

@interface RUNAAppInfoTests : XCTestCase

@property RUNAAppInfo* appInfo;

@end

@implementation RUNAAppInfoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _appInfo = [RUNAAppInfo new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_appInfos {
    NSLog(@"%@", self.appInfo);
    XCTAssertEqualObjects(self.appInfo.bundleIdentifier, @"com.apple.dt.xctest.tool");
    XCTAssertEqualObjects(self.appInfo.bundleName, @"xctest");
    XCTAssertNotNil(self.appInfo.bundleVersion);
    XCTAssertNotNil(self.appInfo.bundleShortVersion);
}
@end
