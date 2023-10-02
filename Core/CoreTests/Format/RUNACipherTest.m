//
//  RUNACipherTest.m
//  CoreTests
//
//  Created by Wu, Wei | David | GATD on 2022/10/18.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNACipher.h"

@interface RUNACipher(test)

+ (NSString * _Nullable)cc_md5:(NSString * _Nonnull)text;

@end

@interface RUNACipherTest : XCTestCase

@end

@implementation RUNACipherTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testMD5hex {
    NSString* expectResult = @"571002c02f2144a41617487738060992";
    NSString* text = @"GoiGoiSuuuuuuuuuuuu";
    
    XCTAssertNil([RUNACipher md5Hex:nil]);
    XCTAssertNil([RUNACipher md5Hex:@""]);
    NSString* rs = [RUNACipher md5Hex:text];
    XCTAssertEqualObjects(rs, expectResult);
}

// delete after lifting support version to iOS 13
//- (void)testCC_MD5 {
//    NSString* expectResult = @"571002c02f2144a41617487738060992";
//    NSString* text = @"GoiGoiSuuuuuuuuuuuu";
//
//    NSString* rs = [RUNACipher cc_md5:text];
//    XCTAssertEqualObjects(rs, expectResult);
//}

@end
