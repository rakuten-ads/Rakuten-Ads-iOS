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

@interface RUNAAdWebViewMessageHandlerTests : XCTestCase
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

@implementation RUNAAdWebViewMessageHandlerTests

- (void)testMessageHandler {
    RUNAAdWebViewMessageHandle handle = ^(RUNAAdWebViewMessage * _Nullable message) {};
    
    RUNAAdWebViewMessageHandler *handler1 = [[RUNAAdWebViewMessageHandler alloc]initWithType:@"type1" handle:handle];
    XCTAssertEqualObjects(handler1.type, @"type1");
    XCTAssertNotNil(handler1.handle);
    
    RUNAAdWebViewMessageHandler *handler2 = [RUNAAdWebViewMessageHandler messageHandlerWithType:@"type2" handle:handle];
    XCTAssertEqualObjects(handler2.type, @"type2");
    XCTAssertNotNil(handler2.handle);
}

@end
