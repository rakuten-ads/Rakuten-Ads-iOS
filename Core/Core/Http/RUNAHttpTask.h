#import <Foundation/Foundation.h>

@protocol RUNAHttpTaskDelegate<NSObject>

@required
// http URL
-(nonnull NSString*) getUrl;

@optional
// determine should cancel before sending
-(Boolean) shouldCancel;

// prepare the parameters compose for url query
-(nullable NSDictionary*) getQueryParameters;

// specicial configuration on request, such as headers
-(void) processConfig:(nonnull NSMutableURLRequest*) request;

// the body when POST
-(nonnull NSData*) postBody;

// on response
-(void) onResponse:(nullable NSHTTPURLResponse*) response withData:(nullable NSData*) data error:(nullable NSError*) error;

@end

/**
 * implements when enable JSON http session
 */
@protocol RUNAJsonHttpSessionDelegate <RUNAHttpTaskDelegate>

@optional
-(nullable NSDictionary*) postJsonBody;
-(void) onJsonResponse:(nullable NSHTTPURLResponse*) response withData:(nullable NSDictionary*) json error:(nullable NSError*) error;

@end



@interface RUNAHttpTask : NSObject {

@protected
    NSURLSession* _httpSession;
}

-(void) resume;
-(void) syncResume:(dispatch_time_t) timeout;

@property (nonatomic, readonly, nullable) NSURL* underlyingUrl;

@property(nonatomic, weak, nullable) id<RUNAHttpTaskDelegate> httpTaskDelegate;

@end

