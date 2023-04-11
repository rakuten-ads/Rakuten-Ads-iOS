//
//  RUNABidResponseConsumerMock.m
//  CoreTests
//
//  Created by Wu, Wei | David | GATD on 2023/04/10.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import "RUNABidResponseConsumerMock.h"


@implementation RUNAAdInfoMock

@end


@implementation RUNABidResponseConsumerDelegateMock


- (void)onBidResponseFailed:(nonnull NSHTTPURLResponse *)response error:(nullable NSError *)error {
    NSLog(@"onBidResponseFailed");
}

- (void)onBidResponseSuccess:(nonnull NSArray<id<RUNAAdInfo>> *)adInfoList withSessionId:(nonnull NSString *)sessionId {
    NSLog(@"onBidResponseSuccess");
}

- (nonnull id<RUNAAdInfo>)parse:(nonnull NSDictionary *)bid {
    return [RUNAAdInfoMock new];
}

@end
