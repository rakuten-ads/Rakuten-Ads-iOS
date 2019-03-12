#import "RPSURLCoder.h"
#import <UIKit/UIKit.h>

@implementation RPSURLCoder

/**
 * RFC3986 
 */
+(nullable NSString*) encodeURL:(nonnull NSString*) originURL {
    NSMutableCharacterSet* allowedCharacterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowedCharacterSet addCharactersInString:@"-._~"];
    return [originURL stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
}

+(nullable NSString*) decodeURL:(nonnull NSString*) encodedURL {
    return [encodedURL stringByRemovingPercentEncoding];
}

@end
