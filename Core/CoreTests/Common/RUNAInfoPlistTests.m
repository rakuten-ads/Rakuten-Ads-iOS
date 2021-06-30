//
//  RUNAInfoPlistTests.m
//  CoreTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/30.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAInfoPlist.h"

@interface RUNAInfoPlistTests : XCTestCase
@end

@implementation RUNAInfoPlistTests

- (void)testRUNAInfoPlist {
    // NOTE: The test is nil because it depends on the sample app's plist
    RUNAInfoPlist *instance = RUNAInfoPlist.sharedInstance;
    XCTAssertNil(instance.hostURL);
    XCTAssertNil(instance.baseURLJs);
    XCTAssertNil(instance.remoteLogHostURL);
    XCTAssertFalse(instance.remoteLogDisabled);
}

@end
