#import <Foundation/Foundation.h>
#import <RPSCore/RPSWebUserAgent.h>
#import <RPSCore/RPSIdfa.h>
#import <RPSCore/RPSDevice.h>
#import <RPSCore/RPSAppInfo.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSTimeInterval RPS_API_TIMEOUT_INTERVAL;

@interface RPSDefines : NSObject

@property(nonatomic, readonly, nonnull) NSURLSession* httpSession;

@property(nonatomic, readonly, nonnull) RPSWebUserAgent* userAgentInfo;
@property(nonatomic, readonly, nonnull) RPSIdfa* idfaInfo;
@property(nonatomic, readonly, nonnull) RPSDevice* deviceInfo;
@property(nonatomic, readonly, nonnull) RPSAppInfo* appInfo;
@property(nonatomic, readonly, nonnull) NSString* bundleShortVersionString;

+(instancetype) sharedInstance;
+(dispatch_queue_t) sharedQueue;

-(instancetype)init __unavailable;
+(instancetype)new __unavailable;

@end

NS_ASSUME_NONNULL_END
