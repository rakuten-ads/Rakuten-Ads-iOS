//
//  RUNAJSONObjectTests.m
//  CoreTests
//
//  Created by Wu, Wei | David on 2022/07/12.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAJSONObject.h"

@interface RUNAJSONObjectTests : XCTestCase

@end

@implementation RUNAJSONObjectTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_jsonWithRawDictionary {
    RUNAJSONObject* json = [RUNAJSONObject jsonWithRawDictionary:@{
            @"key1" : @"value1", @"key2" : @"value2"
    }];
    XCTAssertEqualObjects(json.rawDict[@"key1"], @"value1");
    XCTAssertEqualObjects(json.rawDict[@"key2"], @"value2");
    XCTAssertEqual(json.rawDict[@"unknownKey"], nil);
}

- (void)test_getString {
    RUNAJSONObject* json = [RUNAJSONObject jsonWithRawDictionary:@{
            @"key1" : @"value1", @"key2" : @"value2"
    }];
    XCTAssertEqualObjects([json getString:@"key1"], @"value1");
    XCTAssertEqualObjects([json getString:@"key2"], @"value2");
    XCTAssertEqual([json getString:@"unknownKey"], nil);
}

- (void)test_getNumber {
    RUNAJSONObject* json = [RUNAJSONObject jsonWithRawDictionary:@{
            @"key1" : @(1), @"key2" : @(2.1)
    }];
    XCTAssertEqual([json getNumber:@"key1"].intValue, 1);
    XCTAssertEqual([json getNumber:@"key2"].floatValue, 2.1f);
    XCTAssertEqual([json getNumber:@"unknownKey"], nil);
}

- (void)test_getBool {
    RUNAJSONObject* json = [RUNAJSONObject jsonWithRawDictionary:@{
            @"key1" : @(YES), @"key2" : @(NO)
    }];
    XCTAssertEqual([json getBoolean:@"key1"], YES);
    XCTAssertEqual([json getBoolean:@"key2"], NO);
    XCTAssertEqual([json getBoolean:@"unknownKey"], NO);
}

- (void)test_getJson {
    RUNAJSONObject* json = [RUNAJSONObject jsonWithRawDictionary:@{
        @"key1" : @{
            @"key11" : @"value11",
        }, @"key2" : @(NO)
    }];
    XCTAssertEqual([json getJson:@"key1"].rawDict.count, 1);
    XCTAssertEqualObjects([[json getJson:@"key1"] getString:@"key11"], @"value11");
    XCTAssertEqual([json getJson:@"key2"], nil);
    XCTAssertEqual([json getJson:@"unknownKey"], nil);
}

- (void)test_getArray {
    RUNAJSONObject* json = [RUNAJSONObject jsonWithRawDictionary:@{
        @"key1" : @[@"value11", @"value12"],
        @"key2" : @(NO)
    }];
    XCTAssertEqual([json getArray:@"key1"].count, 2);
    XCTAssertEqualObjects([json getArray:@"key1"].firstObject, @"value11");
    XCTAssertEqualObjects([json getArray:@"key1"].lastObject, @"value12");
    XCTAssertEqual([json getArray:@"key2"], nil);
    XCTAssertEqual([json getArray:@"unknownKey"], nil);
}

@end
