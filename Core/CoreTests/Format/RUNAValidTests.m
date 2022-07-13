//
//  RUNAValidTests.m
//  CoreTests
//
//  Created by Wu, Wei | David on 2022/07/12.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAValid.h"

@interface RUNAValidTests : XCTestCase

@end

@implementation RUNAValidTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_isEmptyString {
    NSString* str1 = @"abc";
    NSString* strNil = nil;
    NSString* strEmpty = @"";
    XCTAssertFalse([RUNAValid isEmptyString:str1]);
    XCTAssertTrue([RUNAValid isEmptyString:strNil]);
    XCTAssertTrue([RUNAValid isEmptyString:strEmpty]);
}

- (void)test_isNotEmptyString {
    NSString* str1 = @"abc";
    NSString* strNil = nil;
    NSString* strEmpty = @"";
    XCTAssertTrue([RUNAValid isNotEmptyString:str1]);
    XCTAssertFalse([RUNAValid isNotEmptyString:strNil]);
    XCTAssertFalse([RUNAValid isNotEmptyString:strEmpty]);
}

@end
