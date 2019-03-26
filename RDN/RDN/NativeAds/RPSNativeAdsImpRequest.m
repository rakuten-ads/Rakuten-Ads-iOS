//
//  RPSNativeAdsImpRequest.m
//  RDN
//
//  Created by Wu, Wei b on 2019/03/25.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSNativeAdsImpRequest.h"
#import "RPSDefines.h"

@implementation RPSNativeAdsImpRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_httpSession = RPSDefines.sharedInstance.httpSession;
        self.shouldKeepHttpSession = YES;
        self.httpSessionDelegate = self;
    }
    return self;
}

- (nonnull NSString *)getUrl {
    return self.impLink;
}

@end
