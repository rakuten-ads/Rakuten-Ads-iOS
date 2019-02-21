//
//  RPSAdRequest.m
//  RsspSDK
//
//  Created by Wu Wei on 2018/07/24.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RPSAdRequest.h"
#import "RPSDefines.h"
#import "RPSRDN.h"

@implementation RPSAdRequest

-(instancetype)initWithAdSpotId:(NSString *)adSpotId {
    self = [super init];
    if (self) {
        self.httpSessionDelegate = self;
        self->_adSpotId = adSpotId;
        self->_httpSession = RPSDefines.sharedInstance.httpSession;
        self.shouldKeepHttpSession = YES;
    }
    return self;
}

- (nonnull NSString *)getUrl {
    return [NSString stringWithFormat:@"%@/a", RPS_DOMAIN_BID];
}

-(NSDictionary *)getQueryParameters {
    RPSDefines* defs = RPSDefines.sharedInstance;
    [defs.userAgentInfo syncResult];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       @{
                                         @"t": self.adSpotId,
                                         @"os": @"ios",
                                         @"ua": defs.userAgentInfo.userAgent ?: @"",
                                         @"l": defs.deviceInfo.language ?: @"",
                                         @"ov": defs.deviceInfo.osVersion ?: @"",
                                         @"dm": defs.deviceInfo.model ?: @"",
                                         @"ob": defs.deviceInfo.buildName ?: @"",
                                         @"sv": [NSString stringWithFormat:@"%lf", RPSRDNVersionNumber],
                                         @"bd": defs.appInfo.bundleIdentifier ?: @"",
                                         @"av": defs.appInfo.bundleShortVersion ?: @"",
                                         }];
    
    if (defs.idfaInfo.trackingEnabled) {
        [parameters setValue:defs.idfaInfo.idfa forKey:@"if"];
    }
    return parameters;
}

-(void)onJsonResponse:(NSHTTPURLResponse *)response withData:(NSDictionary *)json {
    if (self.delegate) {
        if (json) {
            RPSAdSpotInfo* adSpotInfo = [RPSAdSpotInfo adSpotInfoFrom:json];
            RPSLog(@"call adRequestOnSuccess");
            [self.delegate adRequestOnSuccess:adSpotInfo];
        } else {
            RPSLog(@"call adRequestOnFailure");
            [self.delegate adRequestOnFailure];
        }
    }
    RPSLog(@"AdRequest Delegate %@", self.delegate ? @"found" : @"not found");
}

@end
