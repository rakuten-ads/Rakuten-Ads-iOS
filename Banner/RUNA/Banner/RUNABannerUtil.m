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

    NSError* error = nil;
    NSRegularExpression* regx = [NSRegularExpression regularExpressionWithPattern:@"\\s{2,}" options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        RUNADebug("regularExpressionWithPattern '\\s{2,}' error: %@", error);
    } else {
        normalizedText = [regx stringByReplacingMatchesInString:normalizedText options:0 range:NSMakeRange(0, normalizedText.length) withTemplate:@" "] ;
    }

    return normalizedText;
}

@end
