//
//  RUNACipher.m
//  Core
//
//  Created by Wu, Wei | David | GATD on 2022/10/14.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import "RUNACipher.h"
#import "RUNAValid.h"
@import CommonCrypto;

@implementation RUNACipher

+(NSString*) md5Hex:(NSString*) text {
    if ([RUNAValid isEmptyString:text]) {
        return nil;
    }

    return [RUNACryptoWrapper md5HexWithText:text];
}

/* deprecated from iOS 13
+ (NSString * _Nullable)cc_md5:(NSString * _Nonnull)text {
    unsigned int len = (unsigned int)[text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    unsigned char output[CC_MD5_DIGEST_LENGTH];
    CC_MD5(text.UTF8String, len, output);
    return [self toHexString:output length:CC_MD5_DIGEST_LENGTH];
}
 */

+ (nonnull NSString*) toHexString:(unsigned char*) data length: (unsigned int) length {
    NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
    for (unsigned int i = 0; i < length; i++) {
        [hash appendFormat:@"%02x", data[i]];
        data[i] = 0;
    }
    return [hash copy];
}

@end
