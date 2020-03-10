@interface RUNAIdfa : NSObject

@property (nonatomic, readonly, nullable) NSString* idfa;
@property (nonatomic, readonly, getter = isTrackingEnabled) BOOL trackingEnabled;

@end
