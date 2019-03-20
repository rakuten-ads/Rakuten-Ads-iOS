//
//  RPSNativeAdsAdapter.m
//  RDN
//
//  Created by Wu, Wei b on 2019/03/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSNativeAdsAdapter.h"


@implementation RPSNativeAdsAdapter
@synthesize adspotIdList = _adspotIdList;

-(NSArray<NSString *> *)adspotIdList {
    if (self.adspotId) {
        return @[self.adspotId];
    }
    return nil;
}


@end
