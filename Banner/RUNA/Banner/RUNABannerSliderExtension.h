//
//  RUNABannerSliderView.h
//  Banner
//
//  Created by Wu, Wei | David on 2021/09/03.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RUNABannerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNABannerSliderView : UIView

@property(nonatomic, copy, nullable) NSArray<NSString*>* adSpotIds;
@property(nonatomic, nullable) NSArray<RUNABannerView*>* itemViews;

@property(nonatomic) CGFloat itemSpacing;
@property(nonatomic) CGFloat paddingHorizontal;
@property(nonatomic) CGFloat minItemOverhangWidth;

-(void) load;
-(void) loadWithEventHandler:(nullable void (^)(RUNABannerSliderView* view, struct RUNABannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END
