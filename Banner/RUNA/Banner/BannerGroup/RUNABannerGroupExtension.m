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
#import <RUNACore/RUNACipher.h>

@implementation RUNABannerGroup(RUNA_Extension)

-(void)setRz:(NSString *)rz {
    if ([RUNAValid isNotEmptyString:rz]) {
        if (!self.userExt) {
            self.userExt = [NSMutableDictionary new];
        }
        self.userExt[@"rz"] = [rz copy];
    }
}

-(void)setRp:(NSString *)rp {
    if ([RUNAValid isNotEmptyString:rp]) {
        self.userId = [rp copy];
    }
}

-(void)setEasyId:(NSString *)easyId {
    if ([RUNAValid isNotEmptyString:easyId]) {
        NSString* hashedEasyId = [RUNACipher md5Hex:easyId];

        if ([RUNAValid isNotEmptyString:hashedEasyId]) {
            if (!self.userExt) {
                self.userExt = [NSMutableDictionary new];
            }

            self.userExt[@"hashedeasyid"] = hashedEasyId;
        }
    }
}

-(void)setRpoint:(NSInteger)rpoint {
    if (rpoint > 0) {
        if (!self.userExt) {
            self.userExt = [NSMutableDictionary new];
        }
        self.userExt[@"rpoint"] = @(rpoint);
    }
}

@end
