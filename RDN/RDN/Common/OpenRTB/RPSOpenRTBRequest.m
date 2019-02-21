//
//  RPSOpenRTBRequest.m
//  RDN
//
//  Created by Wu, Wei b on 2019/02/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSOpenRTBRequest.h"
#import "RPSDefines.h"
#import <RPSCore/RPSDevice.h>

NSString* kRPSBidRequestHost = @"https://s-bid.rx-ad.com/auc";

@implementation RPSBidRequest

@synthesize imp=_imp;
@synthesize app=_app;
@synthesize device=_device;

#pragma mark - HTTPSession Protocol
- (nonnull NSString *)getUrl {
    return kRPSBidRequestHost;
}

-(Boolean)shouldCancel {
    return self.imp == nil;
}

-(NSDictionary *)postJsonBody {
    NSMutableDictionary* body = [NSMutableDictionary dictionary];

    if (self.imp) {
        [body setObject:self.imp forKey:@"imp"];
    }
    if (self.app) {
        [body setObject:self.app forKey:@"app"];
    }
    if (self.device) {
        [body setObject:self.device forKey:@"device"];
    }

    return body;
}

#pragma mark - OpenRTB Protocol
- (nonnull NSArray *)getImp {
    if (!self->_imp) {
        if (self.bidRequestDelegate) {

            if ([self.bidRequestDelegate respondsToSelector:@selector(preferImp)]) {
                self->_imp = [self.bidRequestDelegate preferImp];

            } else {
                NSMutableArray* impList = [NSMutableArray array];
                for (NSString* adspotId in self.bidRequestDelegate.getAdspotIdList) {
                    if (adspotId) {
                        [impList addObject:@{
                                             @"ext" : @{
                                                     @"adspot_id" : adspotId
                                                     }
                                             }];
                    }
                }
                self->_imp = impList;
            }
        }
    }
    return self->_imp;
}

- (nonnull NSDictionary *)getApp {
    if (!self->_app) {
        self->_app = [self defaultApp];
    }
    return self->_app;
}


- (nonnull NSDictionary *)getDevice {
    if (!self->_device) {
        self->_device = [self defaultDevice];
    }
    return self->_device;
}

- (nonnull NSDictionary *)defaultApp {
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

- (nonnull NSDictionary *)defaultDevice {
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

@end
