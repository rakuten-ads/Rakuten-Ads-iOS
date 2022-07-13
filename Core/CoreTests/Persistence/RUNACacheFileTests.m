//
//  RUNACacheFileTests.m
//  CoreTests
//
//  Created by Wu, Wei | David on 2022/07/12.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNACacheFile.h"

@interface RUNACacheFileTests : XCTestCase

@property RUNACacheFile* cache;

@end

@implementation RUNACacheFileTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _cache = [[RUNACacheFile alloc] initWithName:@"unitTestCacheFile"];
    [[NSFileManager defaultManager] removeItemAtPath:_cache.abstractPath error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

NSString* text = @"RUNA SDK saved cache";

- (void)test_01_saveDataToFile {
    XCTAssertFalse(self.cache.isExist);

    NSData* data = [text dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertTrue([self.cache writeData:data]);
    XCTAssertTrue(self.cache.isExist);
}

- (void)test_02_readDataFromFile {
    [self test_01_saveDataToFile];
    NSError* err;
    NSString* str = [self.cache readStringWithError:&err];
    if (err) {
        NSLog(@"read file error: %@", err);
    }
    XCTAssertNil(err);
    XCTAssertEqualObjects(str, text);
}

@end

