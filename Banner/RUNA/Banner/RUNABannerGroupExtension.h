//
//  RUNABannerGroupExtension.h
//  Banner
//
//  Created by Wu, Wei | David on 2021/03/03.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUNABannerGroup.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 Extension for certain properties.
 */
@interface RUNABannerGroup(RUNA_Extension)

/*!
 set RzCookie
 @param rz value of the RzCookie
 */
-(void) setRz:(NSString*) rz;

/*!
 set RpCookie
 @param rp value of the RpCookie
 */
-(void) setRp:(NSString*) rp;

/*!
 set easyId
 @param easyId value of the easyId
 */
-(void) setEasyId:(NSString*) easyId;

@end

NS_ASSUME_NONNULL_END
