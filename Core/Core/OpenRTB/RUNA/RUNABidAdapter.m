//
//  RUNABidRequestAdapter.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/02/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNABidAdapter.h"
#import "RUNAInfoPlist.h"

#if RUNA_PRODUCTION
    NSString* kRUNABidRequestHost = @"https://s-ad.rmp.rakuten.co.jp/ad";
#elif RUNA_STAGING
    NSString* kRUNABidRequestHost = @"https://stg-s-ad.rmp.rakuten.co.jp/ad";
#else
    NSString* kRUNABidRequestHost = @"https://dev-s-ad.rmp.rakuten.co.jp/ad";
#endif

NSInteger kRUNABidResponseUnfilled = 204;

@implementation RUNABidAdapter

- (nonnull NSArray *)getImp {
    return nil;
}

- (nullable NSDictionary *)getApp {
    return nil;
}

- (nullable NSDictionary *)getUser {
    return nil;
}

-(nullable NSDictionary *)getGeo {
    return nil;
}

-(nullable NSDictionary *)getExt {
    return nil;
}

- (nonnull NSString *)getURL {
    return RUNAInfoPlist.sharedInstance.hostURL ?: kRUNABidRequestHost;
}

- (void)onBidResponse:(nonnull NSHTTPURLResponse *)response withBidList:(nonnull NSArray *)bidList sessionId:(nullable NSString*) sessionId {
    if (self.responseConsumer) {
        NSMutableArray* adInfoList = [NSMutableArray array];
        for (NSDictionary* bid in bidList) {
            id<RUNAAdInfo> adInfo = [self.responseConsumer parse:bid];
            if (adInfo) {
                [adInfoList addObject:adInfo];
            }
        }

        if (adInfoList.count > 0) {
            [self.responseConsumer onBidResponseSuccess: adInfoList withSessionId: sessionId];
        } else {
            RUNADebug("Bid data not found");
            [self.responseConsumer onBidResponseFailed: response error:nil];
        }
    }
}

- (void)onBidFailed:(nonnull NSHTTPURLResponse *)response error:(nullable NSError *)error {
    [self.responseConsumer onBidResponseFailed:response error:error];
}

@end
