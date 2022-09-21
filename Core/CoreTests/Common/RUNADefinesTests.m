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
    NSLog(@"%@", RUNADefines.sharedInstance);
    XCTAssertNotNil(RUNADefines.sharedInstance.httpSession);
    XCTAssertNotNil(RUNADefines.sharedInstance.sharedQueue);
    XCTAssertNotNil(RUNADefines.sharedInstance.userAgentInfo);
    XCTAssertNotNil(RUNADefines.sharedInstance.idfaInfo);
    XCTAssertNotNil(RUNADefines.sharedInstance.deviceInfo);
    XCTAssertNotNil(RUNADefines.sharedInstance.appInfo);
    XCTAssertNotNil(RUNADefines.sharedInstance.sdkBundleShortVersionString);
    
    XCTAssertNoThrow([RUNADefines.sharedInstance getRUNASDKVersionString]);
    
}


@end
