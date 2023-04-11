//
//  RUNAOpenRTBTests.m
//  CoreTests
//
//  Created by Wu, Wei | David on 2022/07/26.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAOpenRTB.h"
#import "RUNABidAdapter.h"
#import "RUNABidResponseConsumerMock.h"

@interface RUNAOpenRTBTests : XCTestCase

@property RUNAOpenRTBRequest* request;
@property RUNABidAdapter* adapter;
@property RUNABidResponseConsumerDelegateMock* consumer;

@end

@implementation RUNAOpenRTBTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.request = [RUNAOpenRTBRequest new];
    self.adapter = [RUNABidAdapter new];
    self.consumer = [RUNABidResponseConsumerDelegateMock new];

    self.adapter.responseConsumer = self.consumer;
    self.request.openRTBAdapterDelegate = self.adapter;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_getUrl {
    XCTAssertEqualObjects([self.request getUrl], @"https://dev-s-ad.rmp.rakuten.co.jp/ad");
}

- (void)test_postJsonBody {
    NSDictionary* json = [self.request postJsonBody];
    XCTAssertTrue([json objectForKey:@"app"]);
    XCTAssertTrue([json objectForKey:@"device"]);
}

- (void)test_onJsonResponse200 {
    NSHTTPURLResponse* emptyResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:200 HTTPVersion:nil headerFields:nil];

    [self.request onJsonResponse:emptyResponse withData:nil error:nil];

    NSString* filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"bid" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    [self.request onJsonResponse:emptyResponse withData:json error:nil];
}

- (void)test_onJsonResponse204 {
    NSHTTPURLResponse* emptyResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL new] statusCode:kRUNABidResponseUnfilled HTTPVersion:nil headerFields:nil];

    NSError* err = [[NSError alloc] initWithDomain:@"test domain" code:123 userInfo:@{@"err.message" : @"test error"}];
    [self.request onJsonResponse:emptyResponse withData:@{} error:err];
}
@end
