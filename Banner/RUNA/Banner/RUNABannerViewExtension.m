//
//  RUNABannerViewExtension.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/10/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNABannerViewExtension.h"
#import "RUNABannerViewInner.h"

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

-(void)setPropertyTargeting:(NSDictionary *)target {
    if (target) {
        self.jsonProperties[@"targeting"] = target;
    }
}

@end
