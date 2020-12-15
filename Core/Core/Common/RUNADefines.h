#import <Foundation/Foundation.h>
#import <RUNACore/RUNAWebUserAgent.h>
#import <RUNACore/RUNAIdfa.h>
#import <RUNACore/RUNADevice.h>
#import <RUNACore/RUNAAppInfo.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSTimeInterval RUNA_API_TIMEOUT_INTERVAL;

@interface RUNADefines : NSObject

@property(nonatomic, readonly, nonnull) NSURLSession* httpSession;
@property(nonatomic, readonly, nonnull) dispatch_queue_t sharedQueue;

@property(nonatomic, readonly, nonnull) RUNAWebUserAgent* userAgentInfo;
@property(nonatomic, readonly, nonnull) RUNAIdfa* idfaInfo;
@property(nonatomic, readonly, nonnull) RUNADevice* deviceInfo;
@property(nonatomic, readonly, nonnull) RUNAAppInfo* appInfo;
@property(nonatomic, readonly, nonnull) NSString* sdkBundleShortVersionString;

+(instancetype) sharedInstance;

-(instancetype)init __unavailable;
+(instancetype)new __unavailable;

@end

NS_ASSUME_NONNULL_END
