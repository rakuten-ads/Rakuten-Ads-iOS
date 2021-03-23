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

@interface RUNABannerGroup : NSObject

@property(nonatomic) NSArray<RUNABannerView*>* banners;

-(void) load;
-(void) loadWithEventHandler:(nullable void (^)(RUNABannerGroup* group, RUNABannerView* __nullable view, struct RUNABannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END

#endif
