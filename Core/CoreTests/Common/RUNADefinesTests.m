//
//  RUNADefinesTests.m
//  CoreTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/30.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNADefines.h"

@interface RUNADefinesTests : XCTestCase
@end

@implementation RUNADefinesTests

- (void)testRUNADefines {
    // TODO: Expected value may differ depending on the VM environment
    NSString *description = [NSString stringWithFormat:@"%@", RUNADefines.sharedInstance];
    XCTAssertEqualObjects(description, @"SDK RUNA/Core version: 1.3.0\n"
                          @"IDFA: 00000000-0000-0000-0000-000000000000\n"
                          @"UA: (null)\n"
                          @"Device: OS version: 14.5\n"
                          @"model: x86_64\n"
                          @"build name: 20F71\n"
                          @"language: en\n"
                          @"AppInfo: bundle ID: com.apple.dt.xctest.tool\n"
                          @"bundle version: 18141\n"
                          @"bundle short version: (null)\n"
                          @"bundle name: xctest\n"
                          );
}

@end
