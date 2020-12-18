@import UIKit;

typedef NS_ENUM(NSUInteger, RUNA_DEVICE_CONN_METHOD) {
    RUNA_DEVICE_CONN_METHOD_UNKNOWN,
    RUNA_DEVICE_CONN_METHOD_ETHERNET,
    RUNA_DEVICE_CONN_METHOD_WIFI,
    RUNA_DEVICE_CONN_METHOD_CELLULAR,
};

@interface RUNADevice : NSObject

@property(nonatomic, readonly, nonnull) NSString* osVersion;
@property(nonatomic, readonly, nonnull) NSString* model;
@property(nonatomic, readonly, nonnull) NSString* buildName;
@property(nonatomic, readonly, nonnull) NSString* language;
@property(nonatomic, readonly) RUNA_DEVICE_CONN_METHOD connectionMethod;

-(void) startNetworkMonitorOnQueue:(nonnull dispatch_queue_t) queue;
-(void) cancelNetworkMonitor;

@end
