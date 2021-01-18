//
//  RUNAOpenRTB.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/02/26.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNAOpenRTB.h"
#import "RUNAJSONObject.h"
#import "RUNADefines.h"

@implementation RUNAOpenRTBRequest

#pragma mark - HTTPSession Protocol

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_httpSession = RUNADefines.sharedInstance.httpSession;
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

-(void)processConfig:(NSMutableURLRequest *)request {
    RUNAWebUserAgent* userAgentInfo = RUNADefines.sharedInstance.userAgentInfo;
    [userAgentInfo syncResult];
    [request setValue:userAgentInfo.userAgent forHTTPHeaderField:@"User-Agent"];
}

- (void)onJsonResponse:(NSHTTPURLResponse *)response withData:(nullable NSDictionary *)json error:(nullable NSError *)error {
    NSMutableArray<NSDictionary*>* bidDataList = nil;
    NSString* sessionId = nil;
    if (response.statusCode == 200 && json) {
        bidDataList = [NSMutableArray array];
        RUNAJSONObject* jsonObj = [RUNAJSONObject jsonWithRawDictionary:json];
        sessionId = [jsonObj getString:@"id"];
        for (id seatbid in [jsonObj getArray:@"seatbid"]) {
            if (seatbid && [seatbid isKindOfClass:NSDictionary.class]) {
                RUNAJSONObject* jsonSeatbid = [RUNAJSONObject jsonWithRawDictionary:seatbid];

                for (id bidData in [jsonSeatbid getArray:@"bid"]) {
                    if (bidData && [bidData isKindOfClass:NSDictionary.class]) {
                        [bidDataList addObject:bidData];
                    }
                }
            }
        }
    } else {
        RUNALog("OpenRTB responsed status code: %lu", (unsigned long)response.statusCode);
        if (error) {
            RUNALog("OpenRTB responsed error: %@", error);
            [self.openRTBAdapterDelegate onBidFailed:response error:error];
            return;
        }
    }

    // sort by id
    [bidDataList sortUsingComparator:^NSComparisonResult(NSDictionary*  _Nonnull obj1, NSDictionary*  _Nonnull obj2) {
        return [obj1[@"id"] compare:obj2[@"id"] options:NSNumericSearch];
    }];

    [self.openRTBAdapterDelegate onBidResponse:response withBidList:bidDataList sessionId:sessionId];
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

    NSDictionary* user = self.openRTBAdapterDelegate.getUser;
    if (user && user.count > 0) {
        body[@"user"] = user;
    }

    NSDictionary* ext = self.openRTBAdapterDelegate.getExt;
    if (ext && ext.count > 0) {
        body[@"ext"] = ext;
    }

    if ([self.openRTBAdapterDelegate respondsToSelector:@selector(processBidBody:)]) {
        [self.openRTBAdapterDelegate processBidBody:body];
    }

    return body;
}

- (nonnull NSDictionary *)getApp {
    RUNAAppInfo* appInfo = RUNADefines.sharedInstance.appInfo;
    NSMutableDictionary* jsonApp = [NSMutableDictionary dictionaryWithDictionary:self.openRTBAdapterDelegate.getApp ?: @{}];

    jsonApp[@"name"] = appInfo.bundleName;
    jsonApp[@"bundle"] = appInfo.bundleIdentifier;
    jsonApp[@"ver"] = appInfo.bundleShortVersion;

    return jsonApp;
}

- (nonnull NSDictionary *)getDevice {
    static dispatch_once_t onceToken;
    static NSDictionary* jsonDevice;
    dispatch_once(&onceToken, ^{
        RUNADefines* defines = RUNADefines.sharedInstance;
        [defines.userAgentInfo syncResult];

        RUNADevice* deviceInfo = defines.deviceInfo;
        RUNAIdfa* idfaInfo = defines.idfaInfo;
        UIScreen* screen = UIScreen.mainScreen;

        jsonDevice = @{
            @"ua" : defines.userAgentInfo.userAgent ?: @"",
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
            @"ext" : @{
                    @"sdk_version": defines.sdkBundleShortVersionString,
            },
            // @"geo"
            // @"carrier"
            @"connectiontype" : @(deviceInfo.connectionMethod)
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


