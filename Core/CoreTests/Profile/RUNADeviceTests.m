//
//  RUNADeviceTests.m
//  CoreTests
//
//  Created by Wu, Wei | David on 2022/07/12.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNADevice.h"

@interface RUNADeviceTests : XCTestCase

@property(nonatomic) RUNADevice* device;

@end

@implementation RUNADeviceTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.device = [RUNADevice new];
    [self.device startNetworkMonitorOnQueue: dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self.device cancelNetworkMonitor];
}

- (void)test_deviceInfo {
    NSLog(@"%@", self.device);
    XCTAssertNotNil(self.device.osVersion);
    XCTAssertNotNil(self.device.model);
    XCTAssertNotNil(self.device.buildName);
    XCTAssertNotNil(self.device.language);
    sleep(3);
    XCTAssertEqual(self.device.connectionMethod, RUNA_DEVICE_CONN_METHOD_UNKNOWN);
}

@end
