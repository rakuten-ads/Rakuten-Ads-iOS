//
//  RUNAWebUserAgentTests.m
//  CoreTests
//
//  Created by Wu, Wei | David on 2022/07/12.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAWebUserAgent.h"

@interface RUNAWebUserAgentTests : XCTestCase

@property RUNAWebUserAgent* agent;

@end

@implementation RUNAWebUserAgentTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _agent = [RUNAWebUserAgent new];
    [_agent asyncRequest];
    _agent.timeout = 5;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_useragent {
    XCTAssertNil(_agent.userAgent);

    XCTestExpectation *expectation = [self expectationWithDescription:@"useragent"];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [self.agent syncResult];
        XCTAssertNotNil(self.agent.userAgent);
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}


@end
