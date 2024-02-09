//
//  RUNABidAdapterTests.m
//  CoreTests
//
//  Created by Wu, Wei | David | GATD on 2023/04/10.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNABidAdapter.h"
#import "RUNABidResponseConsumerMock.h"

#pragma - mark mock


#pragma - mark tests
@interface RUNABidAdapterTests : XCTestCase

@property RUNABidAdapter* adapter;
@property RUNABidResponseConsumerDelegateMock* delegate;

@end

@implementation RUNABidAdapterTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.adapter = [RUNABidAdapter new];
    self.delegate = [RUNABidResponseConsumerDelegateMock new];
    self.adapter.responseConsumer = self.delegate;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

FOUNDATION_EXPORT NSString* kRUNABidRequestHost;

- (void)testBody {
    XCTAssertEqual([self.adapter getImp].count, 0);
    XCTAssertEqual([self.adapter getApp].count, 0);
    XCTAssertEqual([self.adapter getExt].count, 0);
    XCTAssertEqualObjects([self.adapter getURL], kRUNABidRequestHost);
    XCTAssertEqual([self.adapter getUser].count, 0);
}

- (void)testResponseSuccess {
    NSHTTPURLResponse* emptyResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:kRUNABidResponseUnfilled HTTPVersion:nil headerFields:nil];
    [self.adapter onBidResponse:emptyResponse withBidList:@[@{}] sessionId:nil];
}

- (void)testResponseSuccessWithEmptyBidList {
    NSHTTPURLResponse* emptyResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:kRUNABidResponseUnfilled HTTPVersion:nil headerFields:nil];
    [self.adapter onBidResponse:emptyResponse withBidList:@[] sessionId:nil];
}

- (void)testResponseFailed {
    NSHTTPURLResponse* emptyResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:kRUNABidResponseUnfilled HTTPVersion:nil headerFields:nil];
    [self.adapter onBidFailed:emptyResponse error:nil];
}

@end

