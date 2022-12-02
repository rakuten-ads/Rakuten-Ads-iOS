//
//  RUNABannerUtility.m
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2022/11/30.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import "RUNABannerUtil.h"

@implementation RUNABannerUtil

+(NSString *)normalize:(NSString *)text {
    if (!text) {
        return text;
    }

    // halfwidth -> fullwidth
    NSString* normalizedText = [text stringByApplyingTransform:NSStringTransformFullwidthToHalfwidth reverse:YES];

    // normalize NFKC
    normalizedText = [normalizedText precomposedStringWithCompatibilityMapping];

    // lower case
    normalizedText = [normalizedText lowercaseString];

    // trim spaces
    normalizedText = [normalizedText stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];

    // replace spaces with single space
    NSError* error = nil;
    NSString* pattern = @"\\s{2,}";
    NSRegularExpression* regx = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        normalizedText = [regx stringByReplacingMatchesInString:normalizedText options:0 range:NSMakeRange(0, normalizedText.length) withTemplate:@" "] ;
    } else {
        RUNADebug("regularExpressionWithPattern '%@' error: %@", pattern, error);
    }

    return normalizedText;
}

@end
