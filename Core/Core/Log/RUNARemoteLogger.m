//
//  RUNARemoteLogger.m
//  Core
//
//  Created by Wu, Wei | David on 2020/12/01.
//  Copyright © 2020 Rakuten MPD. All rights reserved.
//

#import "RUNARemoteLogger.h"
#import "RUNAHttpTask.h"
#import "RUNADefines.h"
#import "RUNAInfoPlist.h"

#if RUNA_PRODUCTION
    NSString* kRUNALogRequestHost = @"https://log.rmp.rakuten.co.jp";
#elif RUNA_STAGING
    NSString* kRUNALogRequestHost = @"https://stg-log.rmp.rakuten.co.jp";
// TODO: [?] uat-log.rmp.rakuten.co.jp
#else
    NSString* kRUNALogRequestHost = @"https://dev-log.rmp.rakuten.co.jp";
#endif

@interface RUNARemoteLogRequest : RUNAHttpTask<RUNAJsonHttpSessionDelegate>

@property (nonatomic, nonnull) RUNADefines* defines;

@property (nonatomic, nonnull, copy) RUNARemoteLogEntity* logInfo;

@end

@interface RUNARemoteLogger()

@property (nonatomic, nonnull) dispatch_queue_t logQueue;
@property (nonatomic, nonnull) NSURLSession* logSession;

@end

#pragma mark -
@implementation RUNARemoteLogRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_httpSession = RUNARemoteLogger.sharedInstance.logSession;
        self.httpTaskDelegate = self;
        self.defines = RUNADefines.sharedInstance;
    }
    return self;
}


# pragma mark - http delegate
- (nonnull NSString *)getUrl {
    return kRUNALogRequestHost;
}

NSString* RUNA_LOG_USER_AGENT = @"RUNA SDK RemoteLog";
- (void)processConfig:(NSMutableURLRequest *)request {
    [request setValue:RUNA_LOG_USER_AGENT forHTTPHeaderField:@"User-Agent"];
}


- (NSDictionary *)postJsonBody {
    NSMutableDictionary* jsonBody = [NSMutableDictionary dictionaryWithDictionary:@{
        @"error_detail" : self.logInfo.errorDetail.toDictionary,
        @"device" : [self device],
        @"app" : [self app],
    }];

    NSDictionary* userInfo = self.logInfo.userInfo.toDictionary;
    if (userInfo && userInfo.count > 0) {
        [jsonBody setObject:userInfo forKey:@"user"];
    }

    NSDictionary* adInfo = self.logInfo.adInfo.toDictionary;
    if (adInfo && adInfo.count > 0) {
        [jsonBody addEntriesFromDictionary:adInfo];
    }

    RUNADebug("[Remote-Log] send log body: %@", jsonBody);
    return jsonBody;
}



- (NSDictionary*) device {
    UIScreen* screen = UIScreen.mainScreen;
    return @{
        @"ua" : self.defines.userAgentInfo.userAgent,
        @"model" : self.defines.deviceInfo.model,
        @"build_name" : self.defines.deviceInfo.buildName,
        @"type" : [self getDeviceType],
        @"ifa" : self.defines.idfaInfo.idfa,
        @"lmt" : self.defines.idfaInfo.trackingEnabled ? @0 : @1,
        @"os_version" : self.defines.deviceInfo.osVersion,
        @"connection_method" : @(self.defines.deviceInfo.connectionMethod),
        @"h": @((int)screen.bounds.size.height),
        @"w": @((int)screen.bounds.size.width),
        @"ratio": @((int)screen.scale),
    };
}

- (NSDictionary*) app {
    return @{
        @"app_id" : self.defines.appInfo.bundleIdentifier,
        @"app_version" : self.defines.appInfo.bundleVersion,
    };
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

@end


#pragma mark -
@implementation RUNARemoteLogger

+ (instancetype)sharedInstance {
    if (RUNAInfoPlist.sharedInstance.remoteLogDisabled) {
        RUNADebug("RemoteLog disabled");
        return nil;
    }

    static RUNARemoteLogger* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [RUNARemoteLogger new];

        // common background queue for logs retained as property
        instance.logQueue = dispatch_queue_create("RUNA.sdk.queue.log", DISPATCH_QUEUE_CONCURRENT);

        // url session uses the common log queue
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        [config setTimeoutIntervalForRequest:RUNA_API_TIMEOUT_INTERVAL];
        NSOperationQueue* sessionQueue = [NSOperationQueue new];
        sessionQueue.underlyingQueue = instance.logQueue;
        instance.logSession = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:sessionQueue];
    });
    return instance;
}

- (void)sendLog:(RUNARemoteLogEntity *)logInfo {
    @try {
        RUNARemoteLogRequest* request = [RUNARemoteLogRequest new];
        request.logInfo = logInfo;
        RUNADebug("[Remote-Log] send log entity: %@", logInfo);
        [request resume];
    } @catch (NSException *exception) {
        RUNADebug("excetion on remote log: %@", exception);
    }
}

@end
