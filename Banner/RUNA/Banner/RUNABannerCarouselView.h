//
//  RUNABannerCarouselView.h
//  Banner
//
//  Created by Wu, Wei | David on 2021/09/03.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RUNABannerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNABannerCarouselView : UIView

@property(nonatomic, copy, nullable) NSArray<NSString*>* adSpotIds;
@property(nonatomic, nullable) NSArray<RUNABannerView*>* itemViews;

@property(nonatomic) CGFloat itemSpacing;
@property(nonatomic) CGFloat paddingHorizontal;
@property(nonatomic) CGFloat minItemOverhangWidth;

/**
 set RzCookie
 */
@property(nonatomic, copy, nullable) NSString* rz;

-(void) load;
-(void) loadWithEventHandler:(nullable void (^)(RUNABannerCarouselView* view, struct RUNABannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END
