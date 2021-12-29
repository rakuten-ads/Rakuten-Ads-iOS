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
typedef UIView* _Nonnull (^RUNABannerCarouselViewItemDecorator)(RUNABannerView* view, NSInteger position);

typedef NS_ENUM(NSUInteger, RUNABannerCarouselViewItemScale) {
    RUNABannerCarouselViewItemScaleAspectFit,
    RUNABannerCarouselViewItemScaleFixedWidth,
};

@interface RUNABannerCarouselView : UIView

@property(nonatomic, copy, nullable) NSArray<NSString*>* adSpotIds;
@property(nonatomic) RUNABannerCarouselViewItemScale itemScaleMode;

@property(nonatomic, nullable) NSArray<RUNABannerView*>* itemViews;
@property(nonatomic) CGFloat itemSpacing;
@property(nonatomic) UIEdgeInsets contentEdgeInsets;
@property(nonatomic) CGFloat minItemOverhangWidth;

@property(nonatomic) UIEdgeInsets itemEdgeInsets;
@property(nonatomic, copy, nullable) RUNABannerCarouselViewItemDecorator decorator;

@property(nonatomic) CGFloat indicatedItemWidth;

@property(nonatomic, readonly) NSInteger itemCount;

-(void) load;
-(void) loadWithEventHandler:(nullable void (^)(RUNABannerCarouselView* view, struct RUNABannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END
