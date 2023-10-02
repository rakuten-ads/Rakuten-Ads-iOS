//
//  RUNAInterstitialAd.h
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/08.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <RUNABanner/RUNABanner.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Enumerations of the size scale option
 */
typedef NS_ENUM(NSUInteger, RUNAInterstitialAdSize) {
    /// scale the ad content to fit screen size while keeping aspect ratio.
    RUNAInterstitialAdSizeAspectFit,
    /// show original size of ad content without scale.
    RUNAInterstitialAdSizeOriginal,
    /// no indicated size, work with RUNAInterstitialAdCustomDecorator  for customize purpose.
    RUNAInterstitialAdSizeCustom,
};

/*!
 @typedef Callback function for customizing size & position between the root container view & the ad content view when RUNAInterstitialAdSizeCustom enabled.
 @param containerView the root container view
 @param adView the ad content view
 @param closeButton the close button view
 */
typedef void (^RUNAInterstitialAdCustomDecorator)(UIView* const containerView, UIView* const adView, UIImageView* const closeButton);

/*!
 A helper class shows an interstitial ad base on RUNABannerView in a full screen UIViewController after ad content preloaded successfully.
 */
@interface RUNAInterstitialAd: NSObject

// Basic properties

/// unique id from admin site, required when `adSpotCode` is nil.
@property(nonatomic, copy, nullable) NSString* adSpotId;
/// unique code from admin site, required when `adSpotId` is nil.
@property(nonatomic, copy, nullable) NSString* adSpotCode;

// Advanced properties

/// the size scale option, default is RUNAInterstitialAdSizeAspectFit.
@property(nonatomic) RUNAInterstitialAdSize size;
/// A callback block to customize the interstitial ad view.
@property(nonatomic, copy, nullable) RUNAInterstitialAdCustomDecorator decorator;
/// to replace the default image of the close button.
@property(nonatomic, nullable) UIImage* preferredCloseButtonImage;

/// result of loading, true for succeeded
@property(nonatomic, readonly) BOOL loadSucceeded;

/// set the ad content view when needing more complex parameters
/// Notice:
/// - Must not call `load` method from this property, RUNAInterstitialAd will call it instead.
/// - RUNAInterstitialAd will arrange RUNABannerView's layout, thus the properties like `size`, `position` of RUNABannerView will be ignored.
@property(nonatomic, nullable) RUNABannerView* adContentView;

#pragma mark - APIs
/*!
 Request & load ad content with a handler.
 @param handler
 callback to handle variety events.
 */
-(void) preloadWithEventHandler:(nullable void (^)(RUNAInterstitialAd* adView, struct RUNABannerViewEvent event)) handler;

/*!
 Show interstitial ad only when ad content is ready.
 @param parentViewController
 container ViewController where presenting interstitial ad
 @return YES for showing successfully, NO for the opposition.
 */
-(BOOL)showIn:(UIViewController*) parentViewController;

@end

NS_ASSUME_NONNULL_END
