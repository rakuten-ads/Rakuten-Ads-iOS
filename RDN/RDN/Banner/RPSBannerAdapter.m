//
//  RPSBannerAdapter.m
//  RDN
//
//  Created by Wu, Wei b on 2019/02/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSBannerAdapter.h"
#import <RPSCore/RPSJSONObject.h>

@implementation RPSBanner

-(void)parse:(NSDictionary *)bidData {
    RPSJSONObject* jsonBid = [RPSJSONObject jsonWithRawDictionary:bidData];
    self->_html = [jsonBid getString:@"adm"];
    self->_width = [[jsonBid getNumber:@"w"] floatValue];
    self->_height = [[jsonBid getNumber:@"h"] floatValue];

    RPSJSONObject* ext = [jsonBid getJson:@"ext"];
    if (ext) {
        self->_measuredURL = [ext getString:@"measured_url"];
        self->_inviewURL = [ext getString:@"inview_url"];
    }
}

@end

@implementation RPSBannerAdapter

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
