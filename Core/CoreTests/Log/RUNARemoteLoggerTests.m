//
//  RUNARemoteLoggerTests.m
//  CoreTests
//
//  Created by Wu, Wei | David on 2022/07/15.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNARemoteLogger.h"

@interface RUNARemoteLoggerTests : XCTestCase

@end

@implementation RUNARemoteLoggerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_sendEmpty {
    RUNARemoteLogEntity* log = [RUNARemoteLogEntity logWithError:nil andUserInfo:nil adInfo:nil];
    [RUNARemoteLogger.sharedInstance sendLog:log];
}

- (void)test_sendEmptyError {
    RUNARemoteLogEntityErrorDetail* error = [[RUNARemoteLogEntityErrorDetail alloc] init];
    RUNARemoteLogEntity* log = [RUNARemoteLogEntity logWithError:error andUserInfo:nil adInfo:nil];
    [RUNARemoteLogger.sharedInstance sendLog:log];
}

- (void)test_send {
    RUNARemoteLogEntityErrorDetail* error = [[RUNARemoteLogEntityErrorDetail alloc] init];
    error.tag = @"tag";
    error.errorMessage = @"error_message";
    error.stacktrace = @[@"stack1", @"stack1", @"stack1", @"stack1"];
    error.ext = @{
        @"key1Str" : @"value1",
        @"key2Number" : @(12.3),
        @"key3Bool" : @(YES),
        @"key4Nil" : NSNull.null,
    };
    RUNARemoteLogEntity* log = [RUNARemoteLogEntity logWithError:error andUserInfo:nil adInfo:nil];
    [RUNARemoteLogger.sharedInstance sendLog:log];
}

- (void)test_sendWithUserInfo {
    RUNARemoteLogEntityErrorDetail* error = [RUNARemoteLogEntityErrorDetail new];
    error.tag = @"tag";
    error.errorMessage = @"error_message";
    error.stacktrace = @[@"stack1", @"stack1", @"stack1", @"stack1"];
    error.ext = @{
        @"key1Str" : @"value1",
        @"key2Number" : @(12.3),
        @"key3Bool" : @(YES),
        @"key4Nil" : NSNull.null,
    };

    RUNARemoteLogEntityUser* userInfo = [RUNARemoteLogEntityUser new];
    userInfo.id = @"userId001";
    userInfo.ext = @{
        @"key1Str" : @"value1",
        @"key2Number" : @(12.3),
        @"key3Bool" : @(YES),
        @"key4Nil" : NSNull.null,
    };

    RUNARemoteLogEntity* log = [RUNARemoteLogEntity logWithError:error andUserInfo:userInfo adInfo:nil];
    [RUNARemoteLogger.sharedInstance sendLog:log];
}

- (void)test_sendWithUserInfoAndAdInfo {
    RUNARemoteLogEntityErrorDetail* error = [RUNARemoteLogEntityErrorDetail new];
    error.tag = @"tag";
    error.errorMessage = @"error_message";
    error.stacktrace = @[@"stack1", @"stack1", @"stack1", @"stack1"];
    error.ext = @{
        @"key1Str" : @"value1",
        @"key2Number" : @(12.3),
        @"key3Bool" : @(YES),
        @"key4Nil" : NSNull.null,
    };

    RUNARemoteLogEntityUser* userInfo = [RUNARemoteLogEntityUser new];
    userInfo.id = @"userId001";
    userInfo.ext = @{
        @"key1Str" : @"value1",
        @"key2Number" : @(12.3),
        @"key3Bool" : @(YES),
        @"key4Nil" : NSNull.null,
    };

    RUNARemoteLogEntityAd* adInfo = [RUNARemoteLogEntityAd new];
    adInfo.adspotId = @"adspotId001";
    adInfo.batchAdspotList = @[@"bat001", @"bat002", @"bat003"];
    adInfo.sdkVersion = @"sdkver.unittest";
    adInfo.sessionId = @"sdksession001";

    RUNARemoteLogEntity* log = [RUNARemoteLogEntity logWithError:error andUserInfo:userInfo adInfo:adInfo];
    [RUNARemoteLogger.sharedInstance sendLog:log];
}

@end
