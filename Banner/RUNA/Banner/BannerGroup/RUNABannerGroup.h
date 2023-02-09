//
//  RUNABannerGroup.h
//  Banner
//
//  Created by Wu, Wei | David on 2021/02/19.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUNABannerView.h"

#ifndef RUNABannerGroup_h
#define RUNABannerGroup_h

NS_ASSUME_NONNULL_BEGIN

/*!
 A group request load a bunch of ad requests with distinct contents.
 */
@interface RUNABannerGroup : NSObject

/// a list of banners define ad requests.
/// Must not call `load` method from these banners, RUNABannerGroup will call it instead.
@property(nonatomic) NSArray<RUNABannerView*>* banners;

/*!
load a bunch of banners in a request without event handler.
 */
-(void) load;

/*!
 load a bunch of banners in a request with event handler.
 @param handler callback for events.
 */
-(void) loadWithEventHandler:(nullable void (^)(RUNABannerGroup* group, RUNABannerView* __nullable view, struct RUNABannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END

#endif
