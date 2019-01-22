#import <Foundation/Foundation.h>

@protocol RPSHttpSessionDelegate<NSObject>

@required
// http URL
-(nonnull NSString*) getUrl;

@optional
// determine should cancel before sending
-(Boolean) shouldCancel;

// prepare the parameters compose for url query
-(nullable NSDictionary*) getQueryParameters;

// specicial configuration on request, such as headers
-(void) appendConfig:(nonnull NSMutableURLRequest*) request;

// the body when POST
-(nonnull NSData*) postBody;

// on response
-(void) onResponse:(nullable NSHTTPURLResponse*) response withData:(nullable NSData*) data;

@end

/**
 * implements when enable JSON http session
 */
@protocol RPSJsonHttpSessionDelegate <RPSHttpSessionDelegate>

@optional
-(nullable NSDictionary*) postJsonBody;
-(void) onJsonResponse:(nullable NSHTTPURLResponse*) response withData:(nullable NSDictionary*) json;

@end



@interface RPSHttpSession : NSObject {

@protected
    NSURLSession* _httpSession;
}

-(void) resume;
-(void) syncResume:(dispatch_time_t) timeout;

@property (nonatomic) BOOL shouldKeepHttpSession;
@property (nonatomic, readonly, nullable) NSString* underlyingUrl;

@property(nonatomic, weak, nullable) id<RPSHttpSessionDelegate> httpSessionDelegate;

@end

