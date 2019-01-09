#import <Foundation/Foundation.h>
#import <GAPCore/GAPWebUserAgent.h>
#import <GAPCore/GAPIdfa.h>
#import <GAPCore/GAPDevice.h>

FOUNDATION_EXPORT NSString* GAP_AD_TYPE_BANNER;
FOUNDATION_EXPORT NSString* GAP_AD_TYPE_VIDEO;
FOUNDATION_EXPORT NSString* GAP_AD_TYPE_NATIVE;
FOUNDATION_EXPORT NSString* GAP_AD_TYPE_NATIVE_VIDEO;

FOUNDATION_EXPORT NSString* GAP_SDK_VERSION;
FOUNDATION_EXPORT NSTimeInterval GAP_API_TIMEOUT_INTERVAL;

FOUNDATION_EXPORT NSString* GAP_DOMAIN_BID;

@interface GAPDefines : NSObject

@property(nonatomic, readonly, nonnull) NSURLSession* httpSession;

@property(nonatomic, readonly, nonnull) GAPWebUserAgent* userAgentInfo;
@property(nonatomic, readonly, nonnull) GAPIdfa* idfaInfo;
@property(nonatomic, readonly, nonnull) GAPDevice* deviceInfo;
@property(nonatomic, readonly, nonnull) NSString* bundleId;
@property(nonatomic, readonly, nonnull) NSString* bundleVersion;


+(instancetype) sharedInstance;
+(dispatch_queue_t) sharedQueue;

-(instancetype)init __unavailable;
+(instancetype)new __unavailable;

@end
