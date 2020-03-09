//
//  RUNANativeAdAdapter.m
//  RDN
//
//  Created by Wu, Wei b on 2019/03/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNANativeAdAdapter.h"


@implementation RUNANativeAdAdapter

-(NSArray *)getImp {
    NSMutableArray* impList = [NSMutableArray array];
    for (NSString* adspotId in self.adspotIdList) {
        if (adspotId) {
            [impList addObject:@{
                                 @"ext" : @{
                                         @"adspot_id" : adspotId
                                         }
                                 }];
        }
    }
    return impList;
}

-(NSArray<NSString *> *)adspotIdList {
    if (self.adspotId) {
        return @[self.adspotId];
    }
    return nil;
}


@end
