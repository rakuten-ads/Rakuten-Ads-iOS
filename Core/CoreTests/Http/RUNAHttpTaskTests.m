//
//  RUNAHttpTaskTests.m
//  CoreTests
//
//  Created by Wu, Wei | David on 2022/07/14.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAHttpTask.h"

#pragma - test helper class
FOUNDATION_EXPORT NSString* kRUNABidRequestHost;

@interface RUNAHttpTaskRequestMock : RUNAHttpTask

-(void) configHttpRequest:(NSMutableURLRequest*) request;
-(void) setPostBody:(NSMutableURLRequest*) request;

@end

@implementation RUNAHttpTaskRequestMock

- (instancetype)init {
    self = [super init];
    if (self) {
        self->_httpSession = NSURLSession.sharedSession;
    }
    return self;
}

@end

@interface RUNAHttpTaskRequestDelegateMock : NSObject<RUNAHttpTaskDelegate>

@end

@implementation RUNAHttpTaskRequestDelegateMock


- (nonnull NSString *)getUrl {
    return kRUNABidRequestHost;
}

-(NSDictionary *)getQueryParameters {
    return @{
        @"key1Str" : @"value1",
        @"key2Number" : @(12.3),
        @"key3Bool" : @(YES),
        @"key4Nil" : NSNull.null,
    };
}

-(void)processConfig:(NSMutableURLRequest *)request {
    [request setValue:@"test-case" forHTTPHeaderField:@"x-test"];
}

-(NSData *)postBody {
    return [@"form1=value1&form2=value2" dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)onResponse:(NSHTTPURLResponse *)response withData:(NSData *)data error:(NSError *)error {
    NSLog(@"response code %ld", (long)response.statusCode);
}

@end

@interface RUNAHttpTaskTestRequestJsonDelegate : NSObject<RUNAJsonHttpSessionDelegate>

@end

@implementation RUNAHttpTaskTestRequestJsonDelegate

- (nonnull NSString *)getUrl {
    return kRUNABidRequestHost;
}

-(NSDictionary *)postJsonBody {
    return @{
        @"key1Str" : @"value1",
        @"key2Number" : @(12.3),
        @"key3Bool" : @(YES),
        @"key4Nil" : NSNull.null,
    };
}

-(void)onJsonResponse:(NSHTTPURLResponse *)response withData:(NSDictionary *)json error:(NSError *)error {
    NSLog(@"response code %ld", (long)response.statusCode);
}

@end


#pragma - tests
@interface RUNAHttpTaskTests : XCTestCase

@property RUNAHttpTaskRequestMock* httpTask;
@property RUNAHttpTaskRequestDelegateMock* delegate;
@property RUNAHttpTaskTestRequestJsonDelegate* jsonDelegate;

@end

@implementation RUNAHttpTaskTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _httpTask = [RUNAHttpTaskRequestMock new];
    _delegate = [RUNAHttpTaskRequestDelegateMock new];
    _jsonDelegate = [RUNAHttpTaskTestRequestJsonDelegate new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_underlyingUrl {
    _httpTask.httpTaskDelegate = _delegate;
    NSString* result = [NSString stringWithFormat:@"%@?key2Number=12.3&key1Str=value1&key4Nil=&key3Bool=1", kRUNABidRequestHost];

    XCTAssertEqualObjects(self.httpTask.underlyingUrl.absoluteString, result);
}

- (void)test_underlyingUrl_json {
    _httpTask.httpTaskDelegate = _jsonDelegate;

    XCTAssertEqualObjects(self.httpTask.underlyingUrl.absoluteString, kRUNABidRequestHost);
}

- (void)test_configHttpRequest {
    _httpTask.httpTaskDelegate = _delegate;

    NSMutableURLRequest* request = [NSMutableURLRequest new];
    [self.httpTask configHttpRequest:request];
    XCTAssertEqualObjects([request.allHTTPHeaderFields objectForKey:@"x-test"], @"test-case");
}

- (void)test_configHttpRequest_json {
    _httpTask.httpTaskDelegate = _jsonDelegate;

    NSMutableURLRequest* request = [NSMutableURLRequest new];
    [self.httpTask configHttpRequest:request];
    XCTAssertEqualObjects([request.allHTTPHeaderFields objectForKey:@"Accept"], @"application/json");
    XCTAssertEqualObjects([request.allHTTPHeaderFields objectForKey:@"Content-Type"], @"application/json; charset=utf-8");
}

- (void)test_postBody {
    _httpTask.httpTaskDelegate = _delegate;
    NSMutableURLRequest* request = [NSMutableURLRequest new];
    [self.httpTask setPostBody:request];
    NSString* str = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(str, @"form1=value1&form2=value2");
}

- (void)test_postJsobBody {
    _httpTask.httpTaskDelegate = _jsonDelegate;
    NSMutableURLRequest* request = [NSMutableURLRequest new];
    [self.httpTask setPostBody:request];
    NSString* str = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(str, @"{\"key2Number\":12.300000000000001,\"key1Str\":\"value1\",\"key4Nil\":null,\"key3Bool\":true}");
}

- (void)test_resume {
    _httpTask.httpTaskDelegate = _delegate;
    [_httpTask resume];
    sleep(3);
}

- (void)test_resume_json {
    _httpTask.httpTaskDelegate = _jsonDelegate;
    [_httpTask resume];
    sleep(3);
}

@end
