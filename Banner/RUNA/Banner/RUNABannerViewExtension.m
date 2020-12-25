//
//  RUNABannerViewExtension.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/10/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNABannerViewExtension.h"
#import "RUNABannerViewInner.h"
#import <RUNACore/RUNAValid.h>

@implementation RUNABannerViewGenreProperty

-(instancetype)initWithMasterId:(NSInteger)masterId code:(NSString *)code match:(NSString *)match {
    self = [super init];
    if (self) {
        self->_masterId = masterId;
        self->_code = code;
        self->_match = match;
    }
    return self;
}

@end

@implementation RUNABannerView(RUNA_Extension)

-(void)setPropertyGenre:(RUNABannerViewGenreProperty *)matchingGenre {
    if (matchingGenre) {
        self.jsonProperties[@"genre"] = @{
            @"master_id" : @(matchingGenre.masterId),
            @"code" : matchingGenre.code ?: NSNull.null,
            @"match" : matchingGenre.match ?: NSNull.null,
        };
    }
}

-(void)setCustomTargeting:(NSDictionary *)target {
    if (target) {
        self.jsonProperties[@"targeting"] = target;
    }
}

-(void)setRz:(NSString *)rz {
    if ([RUNAValid isNotEmptyString:rz]) {
        self.userExt = @{
            @"rz" : rz
        };
    }
}

-(void) setLocationWithLatitude:(double) lat longitude:(double) lon {
    if (lat < -90.0 || lat > 90.0) {
        NSLog(@"[RUNA] illegal latitude value, must be from -90.0 to +90.0, where nagative is south!");
        return;
    }
    if (lon < -180.0 || lon > 180.0) {
        NSLog(@"[RUNA] illegal longitude value, must be from -180.0 to +180.0, where nagative is west!");
        return;
    }

    RUNAGeo* geo = [RUNAGeo new];
    geo.latitude = lat;
    geo.longitude = lon;
    self.geo = geo;
}
@end
