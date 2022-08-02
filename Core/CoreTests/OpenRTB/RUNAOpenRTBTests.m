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

@interface RUNAOpenRTBTests : XCTestCase

@property RUNAOpenRTBRequest* request;

@end

@implementation RUNAOpenRTBTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.request = [RUNAOpenRTBRequest new];
    self.request.openRTBAdapterDelegate = [RUNABidAdapter new];
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

@end
