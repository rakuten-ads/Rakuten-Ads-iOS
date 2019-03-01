//
//  RPSBidRequestBuilder.m
//  RDN
//
//  Created by Wu, Wei b on 2019/02/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSBidBuilder.h"
#import "RPSDefines.h"

NSString* kRPSBidRequestHost = @"https://s-bid.rx-ad.com/auc";


@implementation RPSBidBuilder

- (nonnull NSDictionary *)getApp {
    static dispatch_once_t onceToken;
    static NSDictionary* jsonApp;
    dispatch_once(&onceToken, ^{
        RPSDefines* defines = RPSDefines.sharedInstance;
        RPSAppInfo* appInfo = defines.appInfo;
        jsonApp = @{
                    @"name": appInfo.bundleName,
                    @"bundle": appInfo.bundleIdentifier,
                    @"ver": appInfo.bundleShortVersion,
                    };
    });
    return jsonApp;
}

- (nonnull NSDictionary *)getDevice {
    static dispatch_once_t onceToken;
    static NSDictionary* jsonDevice;
    dispatch_once(&onceToken, ^{
        RPSDefines* defines = RPSDefines.sharedInstance;
        [defines.userAgentInfo syncResult];

        RPSDevice* deviceInfo = defines.deviceInfo;
        RPSIdfa* idfaInfo = defines.idfaInfo;
        UIScreen* screen = UIScreen.mainScreen;

        jsonDevice = @{
                       @"ua" : defines.userAgentInfo.userAgent,
                       // @"devicetype" : @1,
                       @"make": @"Apple",
                       @"model": deviceInfo.model,
                       @"os": @"iOS",
                       @"osv": deviceInfo.osVersion,
                       @"hwv": deviceInfo.buildName,
                       @"h": @((int)screen.bounds.size.height),
                       @"w": @((int)screen.bounds.size.width),
                       @"ppi": @((int)(160 * screen.scale)),
                       @"pxratio": @((int)screen.scale),
                       @"language": deviceInfo.language,
                       @"ifa": idfaInfo.idfa,
                       @"lmt": idfaInfo.isTrackingEnabled ? @0 : @1,
                       // @"geo"
                       // @"carrier"
                       // @"connectiontype"
                       };
    });
    return jsonDevice;
}

- (nonnull NSArray *)getImp {
    NSMutableArray* impList = [NSMutableArray array];
    for (NSString* adspotId in self.adspotIdList) {
        if (adspotId) {
            [impList addObject:@{
                                 @"ext" : @{
                                         @"adspot_id" : adspotId
                                         }
                                 }];
        }
    }
    return impList;
}

- (nonnull NSString *)getURL {
    return kRPSBidRequestHost;
}

- (void)onBidResponse:(nonnull NSHTTPURLResponse *)response withBidList:(nonnull NSArray *)bidList {
    if (self.responseConsumer) {
        NSMutableArray* adInfoList = [NSMutableArray array];
        for (NSDictionary* bid in bidList) {
            id<RPSAdInfo> adInfo = [self.responseConsumer parse:bid];
            if (adInfo) {
                [adInfoList addObject:adInfo];
            }
        }

        if (adInfoList.count > 0) {
            [self.responseConsumer onBidResponseSuccess:adInfoList];
        } else {
            [self.responseConsumer onBidResponseFailed];
        }
    }
}

@end
