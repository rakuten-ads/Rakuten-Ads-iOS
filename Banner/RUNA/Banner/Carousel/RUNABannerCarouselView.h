//
//  RUNABannerCarouselView.h
//  Banner
//
//  Created by Wu, Wei | David on 2021/09/03.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <RUNABanner/RUNABannerView.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 @typedef Callback function for customizing each ad view with the item view and position index.
 @param view banner item view
 @param position item position in the list
 */
typedef UIView* _Nonnull (^RUNABannerCarouselViewItemDecorator)(RUNABannerView* view, NSInteger position);

/*!
 @enum Enumerations of the itemScaleMode option
 */
typedef NS_ENUM(NSUInteger, RUNABannerCarouselViewItemScale) {
    /// Fit the parent width and calculate height with aspect ratio
    RUNABannerCarouselViewItemScaleAspectFit,
    /// Indicate a fixed width and calculate height with aspect ratio
    RUNABannerCarouselViewItemScaleFixedWidth,
};

/*!
 Carousel View container multiple banners with indicated styles.
 */
@interface RUNABannerCarouselView : UIView

// Basic properties

/// Simply indicate an array of `adSpotIds`, get from administrator site
@property(nonatomic, copy, nullable) NSArray<NSString*>* adSpotIds;

/// Simply indicate an array of `adSpotCodes`, get from administrator site
@property(nonatomic, copy, nullable) NSArray<NSString*>* adSpotCodes;

/* Scale modes to determine the item's presenting contains ad content, default as `RUNABannerCarouselViewItemScaleAspectFit`. */
@property(nonatomic) RUNABannerCarouselViewItemScale itemScaleMode;

// Advanced properties for carousel view
/// An array of ad item view as a `RUNABannerView` with complex options, ignores the `adSpotIds` property.
@property(nonatomic, nullable) NSArray<RUNABannerView*>* itemViews;

/// Spacing between item views
@property(nonatomic) CGFloat itemSpacing;

/// Edge insets of the carousel view content.
@property(nonatomic) UIEdgeInsets contentEdgeInsets;

/// Minimum width to overhang the next item view.
@property(nonatomic) CGFloat minItemOverhangWidth;

// Advanced properties for item view

/// Edge insets of each item view.
@property(nonatomic) UIEdgeInsets itemEdgeInsets;

/// A callback block to customize the item view.
@property(nonatomic, copy, nullable) RUNABannerCarouselViewItemDecorator decorator;

/// A fixed with of item view, only enable when itemScaleMode is `RUNABannerCarouselViewItemScaleFixedWidth`.
@property(nonatomic) CGFloat itemWidth;

/// The count of items successfully loaded.
@property(nonatomic, readonly) NSInteger itemCount;

/*!
 Load ad content without event handler.
 */
-(void) load;

/*!
 Load ad content with callback function to monitor events.
 */
-(void) loadWithEventHandler:(nullable void (^)(RUNABannerCarouselView* _Nonnull view, RUNABannerView* _Nullable banner, struct RUNABannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END
