//
//  RPSNativeAdImpRequest.m
//  RDN
//
//  Created by Wu, Wei b on 2019/03/25.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSNativeAdEventTrackRequest.h"
#import "RPSDefines.h"

@implementation RPSNativeAdEventTrackRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_httpSession = RPSDefines.sharedInstance.httpSession;
    }
    return self;
}

@end
