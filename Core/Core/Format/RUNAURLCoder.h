#import <Foundation/Foundation.h>

@interface RUNAURLCoder : NSObject

+(nullable NSString*) encodeURL:(nonnull NSString*) value;
+(nullable NSString*) decodeURL:(nonnull NSString*) encodedURL;

@end
