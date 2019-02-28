//
//  RPSBannerBuilder.m
//  RDN
//
//  Created by Wu, Wei b on 2019/02/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSBannerBuilder.h"
#import <RPSCore/RPSJSONObject.h>

@implementation RPSBanner

+(instancetype)parse:(NSDictionary *)bidData {
    RPSBanner* banner = [RPSBanner new];
    RPSJSONObject* jsonBid = [RPSJSONObject jsonWithRawDictionary:bidData];
    banner->_html = [[jsonBid getString:@"adm"] stringByRemovingPercentEncoding];
    banner->_width = [[jsonBid getNumber:@"w"] intValue];
    banner->_height = [[jsonBid getNumber:@"h"] intValue];
    return banner;
}

@end

@implementation RPSBannerBuilder
@synthesize adspotIdList = _adspotIdList;

-(NSArray<NSString *> *)adspotIdList {
    if (self.adspotId) {
        return @[self.adspotId];
    }
    return nil;
}

@end
