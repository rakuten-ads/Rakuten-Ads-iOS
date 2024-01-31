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
        bidDataList = [NSMutableArray new];
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
        NSString* id1 = obj1[@"id"];
        NSString* id2 = obj2[@"id"];
        if (id1 && id2) {
            return [id1 compare:id2 options:NSNumericSearch];
        } else {
            return NSOrderedSame;
        }
    }];

    [self.openRTBAdapterDelegate onBidResponse:response withBidList:bidDataList sessionId:sessionId];
}


#pragma mark - OpenRTB Protocol
- (nonnull NSDictionary *)postBidBody {
    NSMutableDictionary* body = [NSMutableDictionary new];

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

    jsonApp[@"name"] = appInfo.bundleName ?: NSNull.null;
    jsonApp[@"bundle"] = appInfo.bundleIdentifier ?: NSNull.null;
    jsonApp[@"ver"] = appInfo.bundleShortVersion ?: NSNull.null;

    return jsonApp;
}

- (nonnull NSDictionary *)getDevice {
    NSMutableDictionary* jsonDevice;
    RUNADefines* defines = RUNADefines.sharedInstance;
    [defines.userAgentInfo syncResult];

    RUNADevice* deviceInfo = defines.deviceInfo;
    UIScreen* screen = UIScreen.mainScreen;

    jsonDevice = [NSMutableDictionary new];

    jsonDevice[@"ua"] = defines.userAgentInfo.userAgent ?: @"";
    jsonDevice[@"devicetype"] = [self getDeviceType];
    jsonDevice[@"make"] = @"Apple";
    jsonDevice[@"model"] = deviceInfo.model ?: NSNull.null;
    jsonDevice[@"os"] = @"iOS";
    jsonDevice[@"osv"] = deviceInfo.osVersion ?: NSNull.null;
    jsonDevice[@"hwv"] = deviceInfo.buildName ?: NSNull.null;
    jsonDevice[@"h"] = @((int)screen.bounds.size.height);
    jsonDevice[@"w"] = @((int)screen.bounds.size.width);
    jsonDevice[@"ppi"] = @((int)(160 * screen.scale));
    jsonDevice[@"pxratio"] = @((int)screen.scale);
    jsonDevice[@"language"] = deviceInfo.language ?: NSNull.null;

    jsonDevice[@"ext"] = @{
        @"sdk_version" : [defines getRUNASDKVersionString] ?: NSNull.null,
        @"sdk_versions" : @{
            @"ios" : [self getSdkVersions]
        },
    };
    jsonDevice[@"connectiontype"] = @(deviceInfo.connectionMethod);
    // @"carrier"

    NSDictionary* geo = self.openRTBAdapterDelegate.getGeo;
    if (geo && geo.count > 0) {
        jsonDevice[@"geo"] = geo;
    }
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


NSString* kModuleNameRuna = @"runa";
NSString* kModuleNameCore = @"runa_core";
NSString* kModuleNameBanner = @"runa_banner";
NSString* kModuleNameOmadapter = @"runa_om_adapter";
NSString* kModuleClassOmadapter = @"RUNAOpenMeasurer";
-(NSArray*) getSdkVersions {
    NSMutableDictionary<NSString*, NSString*>* dict = [NSMutableDictionary new];

    NSString* runaSdkVersion = [RUNADefines.sharedInstance getRUNASDKVersionString];
    if (runaSdkVersion) {
        [dict setObject:runaSdkVersion forKey:kModuleNameRuna];
    }

    [dict setObject:RUNADefines.sharedInstance.sdkBundleShortVersionString forKey:kModuleNameCore];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    Class bannerClass = NSClassFromString(kModuleClassBannerView);
    if (bannerClass && [bannerClass respondsToSelector:@selector(versionString)]) {
        NSString* bannerSDKVersion = [bannerClass performSelector:@selector(versionString)];
        if (bannerSDKVersion) {
            [dict setObject:bannerSDKVersion forKey:kModuleNameBanner];
        }
    }

    Class omClass = NSClassFromString(kModuleClassOmadapter);
    if (omClass && [omClass respondsToSelector:@selector(versionString)]) {
        NSString* omadapterSDKVersion = [omClass performSelector:@selector(versionString)];
        if (omadapterSDKVersion) {
            [dict setObject:omadapterSDKVersion forKey:kModuleNameOmadapter];
        }
    }
#pragma clang diagnostic pop

    NSMutableArray* versionList = [NSMutableArray new];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [versionList addObject:@{
            @"module_name" : key,
            @"version" : obj,
        }];
    }];

    return versionList;
}

@end


