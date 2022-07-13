#import <Foundation/Foundation.h>

/*! not compile object */
@interface RUNAURLCoder : NSObject

+(nullable NSString*) encodeURL:(nonnull NSString*) value;
+(nullable NSString*) decodeURL:(nonnull NSString*) encodedURL;

@end
