//
//  RUNADefines.m
//  RsspSDK
//
//  Created by Wu Wei on 2018/07/25.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RUNADefines.h"
#import "RUNACore.h"
#import "RUNAValid.h"

NSTimeInterval RUNA_API_TIMEOUT_INTERVAL = 30;

@implementation RUNADefines

+(instancetype)sharedInstance {
    static RUNADefines* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        instance = [[RUNADefines alloc] initPrivate];
    });
    return instance;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        {
            NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
            [config setTimeoutIntervalForRequest:RUNA_API_TIMEOUT_INTERVAL];

            self->_sharedQueue = dispatch_queue_create("RUNA.sdk.queue", DISPATCH_QUEUE_CONCURRENT);

            NSOperationQueue* sessionQueue = [NSOperationQueue new];
            sessionQueue.underlyingQueue = self->_sharedQueue;
            self->_httpSession = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:sessionQueue];
        }
        
        {
            self->_userAgentInfo = [RUNAWebUserAgent new];
            self->_userAgentInfo.timeout = RUNA_API_TIMEOUT_INTERVAL;
            [self.userAgentInfo asyncRequest];
        }
        {
            self->_idfaInfo = [RUNAIdfa new];
        }
        
        {
            self->_deviceInfo = [RUNADevice new];
            [self.deviceInfo startNetworkMonitor];
        }
        
        {
            self->_appInfo = [RUNAAppInfo new];
        }

        {
            self->_sdkBundleShortVersionString = [[[NSBundle bundleForClass:self.class] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        }
        
    }
    return self;
}

-(NSString *)description {
    [self.userAgentInfo syncResult];
    return [NSString stringWithFormat:
            @"SDK RUNA/Core version: %@\n"
            @"IDFA: %@\n"
            @"UA: %@\n"
            @"Device: %@"
            @"AppInfo: %@\n"
            ,
            self->_sdkBundleShortVersionString,
            self->_idfaInfo.idfa,
            self->_userAgentInfo.userAgent,
            self->_deviceInfo,
            self->_appInfo,
            nil];
}

@end
