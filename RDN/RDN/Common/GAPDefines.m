//
//  GAPDefines.m
//  RsspSDK
//
//  Created by Wu Wei on 2018/07/25.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "GAPDefines.h"
#import "GAPRDN.h"
#import <GAPCore/GAPValid.h>
#import <GAPCore/GAPCore.h>

NSString* GAP_AD_TYPE_BANNER = @"banner";
NSString* GAP_AD_TYPE_VIDEO = @"video";
NSString* GAP_AD_TYPE_NATIVE = @"native";
NSString* GAP_AD_TYPE_NATIVE_VIDEO = @"native_video";

NSTimeInterval GAP_API_TIMEOUT_INTERVAL = 30;

#if STAGING
NSString* GAP_DOMAIN_BID = @"http://stg-s-bid.rmp.rakuten.co.jp"; // Staging
#elif DEBUG
NSString* GAP_DOMAIN_BID = @"http://dev-s-bid.rx-ad.com"; // Developement
#else
NSString* GAP_DOMAIN_BID = @"http://s-bid.rmp.rakuten.co.jp"; // Production
#endif

@implementation GAPDefines {
    dispatch_queue_t _underlyingQueue;
}

+(instancetype)sharedInstance {
    static GAPDefines* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        instance = [[GAPDefines alloc] initPrivate];
    });
    return instance;
}

+(dispatch_queue_t) sharedQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("GAP.sdk.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        {
            NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
            [config setTimeoutIntervalForRequest:GAP_API_TIMEOUT_INTERVAL];
            
            NSOperationQueue* sessionQueue = [NSOperationQueue new];
            sessionQueue.underlyingQueue = [[self class]sharedQueue];
            
            self->_httpSession = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:sessionQueue];
        }
        
        {
            self->_userAgentInfo = [GAPWebUserAgent new];
            [self.userAgentInfo asyncRequest];
        }
        {
            self->_idfaInfo = [GAPIdfa new];
        }
        
        {
            self->_deviceInfo = [GAPDevice new];
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
                        if ([GAPValid isNotEmptyString:self->_bundleVersion]) {
                            if ([GAPValid isEmptyString:self->_bundleId]) {
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
            @"SDK RDN version: %@\n"
            @"SDK Core version: %@\n"
            @"IDFA: %@\n"
            @"UA: %@\n"
            @"%@"
            @"Bundle identifier: %@\n"
            @"Bundle version: %@\n"
            ,
            GAPRDNVersionNumber,
            GAPCoreVersionNumber,
            self->_idfaInfo.idfa,
            self->_userAgentInfo.userAgent,
            [self->_deviceInfo description],
            self->_bundleId,
            self->_bundleVersion,
            nil];
}

@end
