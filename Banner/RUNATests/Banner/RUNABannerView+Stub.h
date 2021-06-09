//
//  RUNABannerView+Stub.h
//  Banner
//
//  Created by Sato, Akihiko | Akkie on 2021/05/25.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUNABannerViewInner.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNABannerView (Stub)
- (instancetype)initWithEventType:(NSString *)type;
- (instancetype)initWithBidData;
+ (NSDictionary *)dummyBidData;
@end

NS_ASSUME_NONNULL_END
