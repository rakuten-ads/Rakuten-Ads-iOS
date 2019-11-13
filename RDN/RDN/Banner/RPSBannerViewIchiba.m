//
//  RPSBannerViewIchiba.m
//  RDN
//
//  Created by Wu, Wei b on 2019/10/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSBannerViewIchiba.h"
#import "RPSBannerViewInner.h"

@implementation RPSBannerViewGenreProperty

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

@implementation RPSBannerView(RPS_Ichiba)

-(void)setPropertyGenre:(RPSBannerViewGenreProperty *)matchingGenre {
    if (matchingGenre) {
        NSDictionary* jsonGenre = @{
            @"master_id" : @(matchingGenre.masterId),
            @"code" : matchingGenre.code ?: [NSNull null],
            @"match" : matchingGenre.match ?: [NSNull null],
        };

        [self.jsonProperties setObject:jsonGenre forKey:@"genre"];
    }
}

-(void)setPropertyTargeting:(NSDictionary *)target {
    if (target) {
        [self.jsonProperties setObject:target forKey:@"targeting"];
    }
}

@end
