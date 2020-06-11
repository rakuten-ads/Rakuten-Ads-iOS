//
//  RUNABannerAdapter.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/02/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNABannerAdapter.h"
#import <RUNACore/RUNAJSONObject.h>

@implementation RUNABanner

-(void)parse:(NSDictionary *)bidData {
    RUNAJSONObject* jsonBid = [RUNAJSONObject jsonWithRawDictionary:bidData];
    self->_html = [jsonBid getString:@"adm"];
    self->_width = [[jsonBid getNumber:@"w"] floatValue];
    self->_height = [[jsonBid getNumber:@"h"] floatValue];

    RUNAJSONObject* ext = [jsonBid getJson:@"ext"];
    if (ext) {
        self->_measuredURL = [ext getString:@"measured_url"];
        self->_inviewURL = [ext getString:@"inview_url"];
    }
}

@end

@implementation RUNABannerAdapter

-(NSArray *)getImp {
    NSMutableArray* impList = [NSMutableArray array];
    for (NSString* adspotId in self.adspotIdList) {
        if (adspotId) {
            [impList addObject:@{
                                 @"ext" : @{
                                         @"adspot_id" : adspotId,
                                         @"json" : self.json ?: [NSNull null],
                                         }
                                 }];
        }
    }
    return impList;
}

-(NSDictionary *)getApp {
    if (self.appContent) {
       return @{
           @"content" : self.appContent
       };
    }
    return @{};
}


-(NSArray<NSString *> *)adspotIdList {
    if (self.adspotId) {
        return @[self.adspotId];
    }
    return nil;
}

@end
