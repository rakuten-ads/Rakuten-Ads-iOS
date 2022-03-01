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
/**
 Callback function for customizing each ad view with the item view and position index.
 */
typedef UIView* _Nonnull (^RUNABannerCarouselViewItemDecorator)(RUNABannerView* view, NSInteger position);

/**
 Enumerations of the itemScaleMode option
 */
typedef NS_ENUM(NSUInteger, RUNABannerCarouselViewItemScale) {
    /* Fit the parent width and calculate height with aspect ratio */
    RUNABannerCarouselViewItemScaleAspectFit,
    /* Indicate a fixed width and calculate height with aspect ratio */
    RUNABannerCarouselViewItemScaleFixedWidth,
};

@interface RUNABannerCarouselView : UIView

/**
 Basic properties
 */
/* Simply indicate an array of `adSpotIds`, get from administrator site */
@property(nonatomic, copy, nullable) NSArray<NSString*>* adSpotIds;
/* Scale modes to determine the item's presenting contains ad content, default as `RUNABannerCarouselViewItemScaleAspectFit`. */
@property(nonatomic) RUNABannerCarouselViewItemScale itemScaleMode;

/**
 Advanced properties for carousel view
 */
/* An array of ad item view as a `RUNABannerView` with complex options, ignores the `adSpotIds` property. */
@property(nonatomic, nullable) NSArray<RUNABannerView*>* itemViews;
/* Spacing between item views. */
@property(nonatomic) CGFloat itemSpacing;
/* Edge insets of the carousel view content. */
@property(nonatomic) UIEdgeInsets contentEdgeInsets;
/* Minimum width to overhang the next item view. */
@property(nonatomic) CGFloat minItemOverhangWidth;

/**
 Advanced properties for item view
 */
/* Edge insets of each item view. */
@property(nonatomic) UIEdgeInsets itemEdgeInsets;
/* A callback block to customize the item view. */
@property(nonatomic, copy, nullable) RUNABannerCarouselViewItemDecorator decorator;
/* A fixed with of item view, only enable when itemScaleMode is `RUNABannerCarouselViewItemScaleFixedWidth`. */
@property(nonatomic) CGFloat itemWidth;
/* The count of items successfully loaded. */
@property(nonatomic, readonly) NSInteger itemCount;

/**
 Load ad content.
 */
-(void) load;

/**
 Load ad content with callback function to monitor events.
 */
-(void) loadWithEventHandler:(nullable void (^)(RUNABannerCarouselView* _Nonnull view, RUNABannerView* _Nullable banner, struct RUNABannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END
