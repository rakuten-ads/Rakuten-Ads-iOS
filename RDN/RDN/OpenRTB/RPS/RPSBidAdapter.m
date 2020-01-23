//
//  RPSBidRequestAdapter.m
//  RDN
//
//  Created by Wu, Wei b on 2019/02/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSBidAdapter.h"
#import "RPSDefines.h"

#if RPS_PRODUCTION
    NSString* kRPSBidRequestHost = @"https://s-ad.rmp.rakuten.co.jp/ad";
#elif RPS_STAGING
    NSString* kRPSBidRequestHost = @"https://stg-s-ad.rmp.rakuten.co.jp/ad";
#else
    NSString* kRPSBidRequestHost = @"https://dev-s-ad.rmp.rakuten.co.jp/ad";
#endif


@implementation RPSBidAdapter

- (nonnull NSArray *)getImp {
    return nil;
}

- (nonnull NSDictionary *)getApp {
    return nil;
}

- (nonnull NSString *)getURL {
    return kRPSBidRequestHost;
}

- (void)onBidResponse:(nonnull NSHTTPURLResponse *)response withBidList:(nonnull NSArray *)bidList {
    if (self.responseConsumer) {
        NSMutableArray* adInfoList = [NSMutableArray array];
        for (NSDictionary* bid in bidList) {
            id<RPSAdInfo> adInfo = [self.responseConsumer parse:bid];
            if (adInfo) {
                [adInfoList addObject:adInfo];
            }
        }

        if (adInfoList.count > 0) {
            [self.responseConsumer onBidResponseSuccess:adInfoList];
        } else {
            RPSDebug("Bid data not found");
            [self.responseConsumer onBidResponseFailed];
        }
    }
}



@end
