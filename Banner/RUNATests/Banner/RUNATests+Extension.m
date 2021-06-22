//
//  RUNATests+Extension.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/22.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNATests+Extension.h"

@implementation XCTest (Extension)

- (void)execute:(XCTestExpectation *)expectation
      delayTime:(int64_t)delayTime
   targetMethod:(void (^)(void))targetMethod
 assertionBlock:(void (^)(void))assertionBlock {
    targetMethod();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayTime * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        assertionBlock();
        [expectation fulfill];
    });
}

- (void)syncExecute:(XCTestExpectation *)expectation
          delayTime:(NSTimeInterval)delayTime
       targetMethod:(void (^)(void))targetMethod
     assertionBlock:(void (^)(void))assertionBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        targetMethod();
        [NSThread sleepForTimeInterval:delayTime];
        assertionBlock();
        [expectation fulfill];
    });
}

@end
