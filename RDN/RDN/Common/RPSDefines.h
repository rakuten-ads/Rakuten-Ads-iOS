#import <Foundation/Foundation.h>
#import <RPSCore/RPSWebUserAgent.h>
#import <RPSCore/RPSIdfa.h>
#import <RPSCore/RPSDevice.h>

FOUNDATION_EXPORT NSString* RPS_AD_TYPE_BANNER;
FOUNDATION_EXPORT NSString* RPS_AD_TYPE_VIDEO;
FOUNDATION_EXPORT NSString* RPS_AD_TYPE_NATIVE;
FOUNDATION_EXPORT NSString* RPS_AD_TYPE_NATIVE_VIDEO;

FOUNDATION_EXPORT NSTimeInterval RPS_API_TIMEOUT_INTERVAL;

FOUNDATION_EXPORT NSString* RPS_DOMAIN_BID;

@interface RPSDefines : NSObject

@property(nonatomic, readonly, nonnull) NSURLSession* httpSession;

@property(nonatomic, readonly, nonnull) RPSWebUserAgent* userAgentInfo;
@property(nonatomic, readonly, nonnull) RPSIdfa* idfaInfo;
@property(nonatomic, readonly, nonnull) RPSDevice* deviceInfo;
@property(nonatomic, readonly, nonnull) NSString* bundleId;
@property(nonatomic, readonly, nonnull) NSString* bundleVersion;


+(instancetype) sharedInstance;
+(dispatch_queue_t) sharedQueue;

-(instancetype)init __unavailable;
+(instancetype)new __unavailable;

@end
