//
//  Header.h
//  Banner
//
//  Created by Wu, Wei | David on 2021/03/03.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#ifndef RUNABannerGroupInner_h
#define RUNABannerGroupInner_h

#ifndef RUNABannerGroup_h
#import "RUNABannerGroup.h"
#endif

#import "RUNABannerViewInner.h"

@interface RUNABannerGroup()

@property (atomic, readonly) RUNABannerViewState state;

@property (nonatomic, nullable) NSDictionary* userExt; /* include rzCookie */
@property (nonatomic, nullable) NSString* userId; /* RpCookie */


@end

#endif /* RUNABannerGroupInner_h */
