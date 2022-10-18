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

+(NSString*) md5:(NSString*) text {
    if ([RUNAValid isEmptyString:text]) {
        return nil;
    }
    
    if (@available(iOS 13, *)) {
        return [RUNACryptoWrapper md5HexWithText:text];
    } else {
        unsigned int len = (unsigned int)[text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        unsigned char output[CC_MD5_DIGEST_LENGTH];
        CC_MD5(text.UTF8String, len, output);
        return [self toHexString:output length:CC_MD5_DIGEST_LENGTH];
    }
    
    return nil;
}

+ (nonnull NSString*) toHexString:(unsigned char*) data length: (unsigned int) length {
    NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
    for (unsigned int i = 0; i < length; i++) {
        [hash appendFormat:@"%02x", data[i]];
        data[i] = 0;
    }
    return [hash copy];
}

@end
