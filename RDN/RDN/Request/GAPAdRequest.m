//
//  GAPAdRequest.m
//  RsspSDK
//
//  Created by Wu Wei on 2018/07/24.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "GAPAdRequest.h"
#import "GAPDefines.h"

@implementation GAPAdRequest

-(instancetype)initWithAdSpotId:(NSString *)adSpotId {
    self = [super init];
    if (self) {
        self.httpSessionDelegate = self;
        self->_adSpotId = adSpotId;
        self->_httpSession = GAPDefines.sharedInstance.httpSession;
        self.shouldKeepHttpSession = YES;
    }
    return self;
}

- (nonnull NSString *)getUrl {
    return [NSString stringWithFormat:@"%@/a", GAP_DOMAIN_BID];
}

-(NSDictionary *)getQueryParameters {
    GAPDefines* defs = GAPDefines.sharedInstance;
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
                                         @"sv": GAP_SDK_VERSION,
                                         @"bd": defs.bundleId ?: @"",
                                         @"av": defs.bundleVersion ?: @"",
                                         }];
    
    if (defs.idfaInfo.trackingEnabled) {
        [parameters setValue:defs.idfaInfo.idfa forKey:@"if"];
    }
    return parameters;
}

-(void)onJsonResponse:(NSHTTPURLResponse *)response withData:(NSDictionary *)json {
    if (self.delegate) {
        if (json) {
            GAPAdSpotInfo* adSpotInfo = [GAPAdSpotInfo adSpotInfoFrom:json];
            GAPLog(@"call adRequestOnSuccess");
            [self.delegate adRequestOnSuccess:adSpotInfo];
        } else {
            GAPLog(@"call adRequestOnFailure");
            [self.delegate adRequestOnFailure];
        }
    }
    GAPLog(@"AdRequest Delegate %@", self.delegate ? @"found" : @"not found");
}

@end
