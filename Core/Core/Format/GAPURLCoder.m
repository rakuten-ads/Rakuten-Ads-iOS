#import "GAPURLCoder.h"
#import <UIKit/UIKit.h>

@implementation GAPURLCoder

/**
 * RFC3986基準
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
