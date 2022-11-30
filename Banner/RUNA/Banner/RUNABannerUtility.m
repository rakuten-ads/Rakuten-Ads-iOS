//
//  RUNABannerUtility.m
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2022/11/30.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import "RUNABannerUtility.h"

@implementation RUNABannerUtility

+(NSString *)normalize:(NSString *)text {
    if (!text) {
        return text;
    }
    NSMutableString* normalizedText = [text mutableCopy];
    // halfwidth -> fullwidth
    [normalizedText applyTransform:NSStringTransformFullwidthToHalfwidth reverse:YES range:NSMakeRange(0, text.length) updatedRange:nil];

    // normalize NFKC
    [normalizedText precomposedStringWithCompatibilityMapping];

    // lower case
    [normalizedText lowercaseString];

    // trim spaces
    [normalizedText stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    [normalizedText stringByReplacingOccurrencesOfString:@"\\s{2,}" withString:@" "];

    return normalizedText;
}

@end
