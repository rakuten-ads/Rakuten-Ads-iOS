//
//  RUNAIdfaTests.m
//  CoreTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/30.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "RUNAIdfa.h"

@interface RUNAIdfa (Spy)
@end

@implementation RUNAIdfa (Spy)
- (instancetype)initWithEmptyParams {
    return [super init];
}
@end

@interface RUNAIdfaTests : XCTestCase
@end

@implementation RUNAIdfaTests

- (void)testIdfa {
    // NOTE: XCTest cannot spoof idfa
    {
        RUNAIdfa *idfa = [[RUNAIdfa alloc]init];
        XCTAssertEqualObjects(idfa.idfa, @"00000000-0000-0000-0000-000000000000");
        XCTAssertFalse(idfa.trackingEnabled);
    }
    {
        RUNAIdfa *idfa = [[RUNAIdfa alloc]initWithEmptyParams];
        XCTAssertEqualObjects(idfa.idfa, @"00000000-0000-0000-0000-000000000000");
    }
    {
        RUNAIdfa *idfa = [[RUNAIdfa alloc]initWithEmptyParams];
        XCTAssertFalse(idfa.trackingEnabled);
    }
}

@end
