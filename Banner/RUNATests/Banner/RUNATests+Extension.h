//
//  RUNATests+Extension.h
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/22.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCTest (Extension)
- (void)execute:(XCTestExpectation *)expectation
      delayTime:(int64_t)delayTime
   targetMethod:(void (^)(void))targetMethod
 assertionBlock:(void (^)(void))assertionBlock;
- (void)syncExecute:(XCTestExpectation *)expectation
          delayTime:(NSTimeInterval)delayTime
       targetMethod:(void (^)(void))targetMethod
     assertionBlock:(void (^)(void))assertionBlock;
@end

NS_ASSUME_NONNULL_END
