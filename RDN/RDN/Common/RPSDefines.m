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

NSString* RPS_AD_TYPE_BANNER = @"banner";
NSString* RPS_AD_TYPE_VIDEO = @"video";
NSString* RPS_AD_TYPE_NATIVE = @"native";
NSString* RPS_AD_TYPE_NATIVE_VIDEO = @"native_video";

NSTimeInterval RPS_API_TIMEOUT_INTERVAL = 30;

#if STAGING
NSString* RPS_DOMAIN_BID = @"http://stg-s-bid.rmp.rakuten.co.jp"; // Staging
#elif DEBUG
NSString* RPS_DOMAIN_BID = @"http://dev-s-bid.rx-ad.com"; // Developement
#else
NSString* RPS_DOMAIN_BID = @"http://s-bid.rmp.rakuten.co.jp"; // Production
#endif

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
            [self.userAgentInfo asyncRequest];
        }
        {
            self->_idfaInfo = [RPSIdfa new];
        }
        
        {
            self->_deviceInfo = [RPSDevice new];
        }
        
        {
            self->_bundleId = NSBundle.mainBundle.bundleIdentifier;
        }
        {
            self->_bundleVersion = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"];
            if (!self->_bundleVersion) {
                // if CFBundleShortVersionString not found in main bundle, like UnitTest
                [NSBundle.allBundles enumerateObjectsUsingBlock:^(NSBundle * _Nonnull bundle, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString* infoPath = [bundle pathForResource:@"Info" ofType:@"plist"];
                    if (infoPath) {
                        NSDictionary* infoDict = [NSDictionary dictionaryWithContentsOfFile:infoPath];
                        self->_bundleVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
                        if ([RPSValid isNotEmptyString:self->_bundleVersion]) {
                            if ([RPSValid isEmptyString:self->_bundleId]) {
                                self->_bundleId = [infoDict objectForKey:@"CFBundleIdentifier"];
                            }
                            *stop = YES;
                        }
                    }
                }];
            }
        }
        
    }
    return self;
}

-(NSString *)description {
    [self.userAgentInfo syncResult];
    return [NSString stringWithFormat:
            @"SDK RDN version: %lf\n"
            @"SDK Core version: %lf\n"
            @"IDFA: %@\n"
            @"UA: %@\n"
            @"%@"
            @"Bundle identifier: %@\n"
            @"Bundle version: %@\n"
            ,
            RPSRDNVersionNumber,
            RPSCoreVersionNumber,
            self->_idfaInfo.idfa,
            self->_userAgentInfo.userAgent,
            [self->_deviceInfo description],
            self->_bundleId,
            self->_bundleVersion,
            nil];
}

@end
