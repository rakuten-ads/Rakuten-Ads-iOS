//
//  RUNAInfoPlistTests.m
//  CoreTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/30.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAInfoPlist.h"

@interface RUNAInfoPlist (test)

- (void) loadFromBundle: (NSBundle*) bundle;

@end

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


- (void)test_loadInfoPlist {

    RUNAInfoPlist* infoPlist = [RUNAInfoPlist new];
    [infoPlist loadFromBundle:[NSBundle bundleForClass:self.class]];
    XCTAssertEqualObjects(infoPlist.hostURL, @"https://dev-s-ad.rmp.rakuten.co.jp/ad");
    XCTAssertEqualObjects(infoPlist.baseURLJs, @"https://dev-s-dlv.rmp.rakuten.co.jp");
    XCTAssertEqualObjects(infoPlist.remoteLogHostURL, @"https://dev-log.rakuten.co.jp/dummy");
    XCTAssertEqual(infoPlist.remoteLogDisabled, YES);
}

@end
