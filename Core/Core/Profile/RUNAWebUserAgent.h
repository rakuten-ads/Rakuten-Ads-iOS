@interface RUNAWebUserAgent : NSObject

@property(atomic, readonly, nullable) NSString* userAgent;
@property(nonatomic) NSInteger timeout;

-(void) asyncRequest;
-(void) syncResult;

@end
