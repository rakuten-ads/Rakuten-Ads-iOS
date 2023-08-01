//
//  RUNABannerUtil.h
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2022/11/30.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Utility tools for Banner
 */
@interface RUNABannerUtil : NSObject

/*!
 Normalize input NSString text for ad content search keywords by following rules:
 - halfwidth -> fullwidth
 - normalize NFKC
 - lower case
 - trim spaces
 - replace spaces with single space
 */
+(NSString*) normalize:(NSString*) text;

@end

NS_ASSUME_NONNULL_END
