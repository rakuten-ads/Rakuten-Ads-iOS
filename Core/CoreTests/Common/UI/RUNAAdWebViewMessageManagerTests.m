//
//  RUNAAdWebViewMessageManagerTests.m
//  CoreTests
//
//  Created by Wu, Wei | David | GATD on 2023/04/10.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAAdWebViewMessageManager.h"

@interface RUNAAdWebViewMessageManagerTests : XCTestCase

@end

@implementation RUNAAdWebViewMessageManagerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAddMessageHandler {
    RUNAAdWebViewMessageManager* manager = [[RUNAAdWebViewMessageManager alloc] initWithName:@"amanager"];
    [manager addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:@"test" handle:^(RUNAAdWebViewMessage * _Nullable message) {
        NSLog(@"handle with test message");
    }]];
    XCTAssertNotNil(manager.messageHandlers[@"test"]);
}

@end
