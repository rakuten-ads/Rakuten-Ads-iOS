//
//  RUNAAdWebViewMessageTests.m
//  CoreTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/29.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAAdWebViewMessage.h"

@interface RUNAAdWebViewMessageTests : XCTestCase
@end

@implementation RUNAAdWebViewMessageTests

- (void)testParse {
    RUNAAdWebViewMessage *message = [RUNAAdWebViewMessage parse:@{
        @"vendor" : @"vendor",
        @"type" : @"type",
        @"url" : @"url"
    }];
    XCTAssertEqualObjects(message.vendor, @"vendor");
    XCTAssertEqualObjects(message.type, @"type");
    XCTAssertEqualObjects(message.url, @"url");
  
    NSString *description = [NSString stringWithFormat:@"%@", message];
    XCTAssertEqualObjects(description, @"{ vendor: vendor, type: type, url: url }");
}

@end
