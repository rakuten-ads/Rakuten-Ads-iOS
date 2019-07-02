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
    NSString* kRPSBidRequestHost = @"https://s-bid.rx-ad.com/auc"; // TODO need confirm
#elseif RPS_STAGING
    NSString* kRPSBidRequestHost = @"https://stg-s-bid.rx-ad.com/auc"; // TODO need confirm
#else
//    NSString* kRPSBidRequestHost = @"http://local.auction.rx-ad.com:5000/auc";
//    NSString* kRPSBidRequestHost = @"https://dev-s-bid.rx-ad.com/auc"; // TODO need confirm
//    NSString* kRPSBidRequestHost = @"https://tst-s-bid.rx-ad.com/sshb/openrtb2/auction";
NSString* kRPSBidRequestHost = @"https://stg-s-bid.rmp.rakuten.co.jp/ad";
#endif


@implementation RPSBidAdapter

- (nonnull NSArray *)getImp {
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
            [self.responseConsumer onBidResponseFailed];
        }
    }
}

@end
