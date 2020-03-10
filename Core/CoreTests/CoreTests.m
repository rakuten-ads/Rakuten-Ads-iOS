//
//  CoreTests.m
//  CoreTests
//
//  Created by Wu, Wei b on 2019/01/09.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RUNACore/RUNACore.h>

@interface CoreTests : XCTestCase

@end

@implementation CoreTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSLog(@"version number = %lf", RUNACoreVersionNumber);
    NSLog(@"version = %s", RUNACoreVersionString);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
