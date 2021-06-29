//
//  RUNAAdSessioTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/28.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAAdSessionInner.h"

@interface RUNAAdSessioTest : XCTestCase
@end

@implementation RUNAAdSessioTest

- (void)testInit {
    RUNAAdSession *session = [[RUNAAdSession alloc]init];
    XCTAssertNotNil(session.uuid);
}

- (void)testAddBlockAd {
    RUNAAdSession *session = [[RUNAAdSession alloc]init];
    [session addBlockAd:111];
    XCTAssertEqual(session.blockAdList.count, (NSUInteger)1);
    XCTAssertEqual(session.blockAdList[0], [NSNumber numberWithInteger:111]);
    [session addBlockAd:222];
    XCTAssertEqual(session.blockAdList.count, (NSUInteger)2);
    XCTAssertEqual(session.blockAdList[1], [NSNumber numberWithInteger:222]);
    [session addBlockAd:333];
    XCTAssertEqual(session.blockAdList.count, (NSUInteger)3);
    XCTAssertEqual(session.blockAdList[2], [NSNumber numberWithInteger:333]);
}

@end
