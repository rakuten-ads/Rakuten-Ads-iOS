//
//  RUNABannerGroupExtension.m
//  Banner
//
//  Created by Wu, Wei | David on 2021/03/03.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNABannerGroupExtension.h"
#import "RUNABannerGroupInner.h"
#import <RUNAcore/RUNAValid.h>

@implementation RUNABannerGroup(RUNA_Extension)

-(void)setRz:(NSString *)rz {
    if ([RUNAValid isNotEmptyString:rz]) {
        self.userExt = @{
            @"rz" : [rz copy]
        };
    }
}

-(void)setRp:(NSString *)rp {
    if ([RUNAValid isNotEmptyString:rp]) {
        self.userId = [rp copy];
    }
}

@end
