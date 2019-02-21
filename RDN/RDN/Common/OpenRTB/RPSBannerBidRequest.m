//
//  RPSBannerBidRequest.m
//  RDN
//
//  Created by Wu, Wei b on 2019/02/21.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSBannerBidRequest.h"

@implementation RPSBannerBidRequest

- (nonnull NSArray<NSString *> *)getAdspotIdList {
    return @[self.adspotId];
}

@end
