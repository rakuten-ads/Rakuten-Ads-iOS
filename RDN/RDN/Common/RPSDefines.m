//
//  RPSDefines.m
//  RsspSDK
//
//  Created by Wu Wei on 2018/07/25.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RPSDefines.h"
#import "RPSRDN.h"
#import <RPSCore/RPSCore.h>
#import <RPSCore/RPSValid.h>

NSTimeInterval RPS_API_TIMEOUT_INTERVAL = 30;

@implementation RPSDefines {
    dispatch_queue_t _underlyingQueue;
}

+(instancetype)sharedInstance {
    static RPSDefines* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        instance = [[RPSDefines alloc] initPrivate];
    });
    return instance;
}

+(dispatch_queue_t) sharedQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("RPS.sdk.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        {
            NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
            [config setTimeoutIntervalForRequest:RPS_API_TIMEOUT_INTERVAL];
            
            NSOperationQueue* sessionQueue = [NSOperationQueue new];
            sessionQueue.underlyingQueue = [[self class]sharedQueue];
            
            self->_httpSession = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:sessionQueue];
        }
        
        {
            self->_userAgentInfo = [RPSWebUserAgent new];
            self->_userAgentInfo.timeout = RPS_API_TIMEOUT_INTERVAL;
            [self.userAgentInfo asyncRequest];
        }
        {
            self->_idfaInfo = [RPSIdfa new];
        }
        
        {
            self->_deviceInfo = [RPSDevice new];
        }
        
        {
            self->_appInfo = [RPSAppInfo new];
        }

        {
            self->_bundleShortVersionString = [[[NSBundle bundleForClass:self.class] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        }
        
    }
    return self;
}

-(NSString *)description {
    [self.userAgentInfo syncResult];
    return [NSString stringWithFormat:
            @"SDK RDN version: %@\n"
            @"SDK Core version: %@\n"
            @"IDFA: %@\n"
            @"UA: %@\n"
            @"Device: %@"
            @"AppInfo: %@\n"
            ,
            self->_bundleShortVersionString,
            [RPSCore bundleVersionShortString],
            self->_idfaInfo.idfa,
            self->_userAgentInfo.userAgent,
            self->_deviceInfo,
            self->_appInfo,
            nil];
}

@end
