@interface GAPWebUserAgent : NSObject

@property(atomic, readonly, nullable) NSString* userAgent;
@property(nonatomic) NSInteger timeout;

-(void) asyncRequest;
-(void) syncResult;

@end
