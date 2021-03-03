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
    self->_impId = [jsonBid getString:@"impid"];
    self->_html = [jsonBid getString:@"adm"];
    self->_width = [[jsonBid getNumber:@"w"] floatValue];
    self->_height = [[jsonBid getNumber:@"h"] floatValue];

    RUNAJSONObject* ext = [jsonBid getJson:@"ext"];
    if (ext) {
        self->_measuredURL = [ext getString:@"measured_url"];
        self->_inviewURL = [ext getString:@"inview_url"];
        self->_viewabilityProviderURL = [ext getString:@"viewability_provider_url"];
        self->_advertiseId = [[ext getNumber:@"advid"] integerValue];
    }
}

@end

@implementation RUNABannerAdapter

-(NSArray *)getImp {
    NSMutableArray* impList = [NSMutableArray array];
    for (RUNABannerImp* imp in self.impList) {
        [impList addObject:@{
            @"id" : imp.id ?: NSNull.null,
            @"banner" : imp.banner ?: NSNull.null,
            @"ext" : @{
                    @"adspot_id" : imp.adspotId ?: NSNull.null,
                    @"json" : imp.json ?: NSNull.null,
            }
        }];

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

-(NSDictionary *)getUser {
    if (self.userExt) {
        return @{
            @"ext" : self.userExt
        };
    }
    return @{};
}

- (NSDictionary *)getGeo {
    if (self.geo) {
        return @{
            @"lat": @(self.geo.latitude),
            @"lon": @(self.geo.longitude)
        };
    }
    return nil;
}

-(NSDictionary *)getExt {
    return @{
        @"badvid" : self.blockAdList ?: @[]
    };
}

@end

@implementation RUNAGeo

-(NSString *)description {
    return [NSString stringWithFormat:@"{ lat: %f, lon: %f }",
            self.latitude,
            self.longitude];
}

@end

@implementation RUNABannerImp

@end
