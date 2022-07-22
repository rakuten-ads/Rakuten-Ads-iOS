//
//  RUNALoggerTests.m
//  CoreTests
//
//  Created by Wu, Wei | David on 2022/07/15.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNALogger.h"

@interface RUNALoggerTests : XCTestCase

@end

@implementation RUNALoggerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_loggerInstance {
    XCTAssertNotNil([RUNALogger sharedLog]);
}
@end
