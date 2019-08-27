//
//  RPSOpenRTB.m
//  RDN
//
//  Created by Wu, Wei b on 2019/02/26.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSOpenRTB.h"
#import <RPSCore/RPSJSONObject.h>
#import "RPSDefines.h"
#import "RPSRDN.h"

@implementation RPSOpenRTBRequest

#pragma mark - HTTPSession Protocol

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_httpSession = RPSDefines.sharedInstance.httpSession;
        self.httpTaskDelegate = self;
    }
    return self;
}

- (nonnull NSString *)getUrl {
    return self.openRTBAdapterDelegate.getURL;
}

-(NSDictionary *)postJsonBody {
    return [self postBidBody];
}

NSString* kSDKUserAgentFormat = @"GAP-SDK:iOS:%@";
-(void)processConfig:(NSMutableURLRequest *)request {
    [request setValue:[NSString stringWithFormat:kSDKUserAgentFormat, RPSDefines.sharedInstance.sdkBundleShortVersionString] forHTTPHeaderField:@"User-Agent"];
}

- (void)onJsonResponse:(NSHTTPURLResponse *)response withData:(NSDictionary *)json {
    NSMutableArray<NSDictionary*>* bidDataList = nil;
    if (response.statusCode == 200) {
        bidDataList = [NSMutableArray array];
        RPSJSONObject* jsonObj = [RPSJSONObject jsonWithRawDictionary:json];
        for (id seatbid in [jsonObj getArray:@"seatbid"]) {
            if (seatbid && [seatbid isKindOfClass:NSDictionary.class]) {
                RPSJSONObject* jsonSeatbid = [RPSJSONObject jsonWithRawDictionary:seatbid];

                for (id bidData in [jsonSeatbid getArray:@"bid"]) {
                    if (bidData && [bidData isKindOfClass:NSDictionary.class]) {
                        [bidDataList addObject:bidData];
                    }
                }
            }
        }
    } else {
        RPSLog("OpenRTB responsed status code: %ld", (long)response.statusCode);
    }

    // sort by id
    [bidDataList sortUsingComparator:^NSComparisonResult(NSDictionary*  _Nonnull obj1, NSDictionary*  _Nonnull obj2) {
        return [obj1[@"id"] compare:obj2[@"id"] options:NSNumericSearch];
    }];

    [self.openRTBAdapterDelegate onBidResponse:response withBidList:bidDataList];
}


#pragma mark - OpenRTB Protocol
- (nonnull NSDictionary *)postBidBody {
    NSMutableDictionary* body = [NSMutableDictionary dictionary];

    NSArray* imp = [self.openRTBAdapterDelegate getImp];
    if (imp) {
        body[@"imp"] = imp;
    }
    body[@"app"] = [self getApp];
    body[@"device"] = [self getDevice];

    if ([self.openRTBAdapterDelegate respondsToSelector:@selector(processBidBody:)]) {
        [self.openRTBAdapterDelegate processBidBody:body];
    }

    return body;
}

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
                       @"devicetype" : [self getDeviceType],
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

/**
 * OpenRTB Sepc 2.5 / 5.21 Device Type
 */
-(NSNumber*) getDeviceType {
    switch (UIScreen.mainScreen.traitCollection.userInterfaceIdiom) {
        case UIUserInterfaceIdiomPhone:
            return [NSNumber numberWithInt:4]; // Phone
        case UIUserInterfaceIdiomPad:
            return [NSNumber numberWithInt:5]; // Tablet
        case UIUserInterfaceIdiomTV:
        case UIUserInterfaceIdiomCarPlay:
            return [NSNumber numberWithInt:6]; // Connected Device
        default:
            return [NSNumber numberWithInt:7]; // Set Top BOx
    }
}

- (NSDictionary*) getCarrier {
    return nil;
}

@end


