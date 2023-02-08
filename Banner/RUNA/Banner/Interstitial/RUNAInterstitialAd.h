//
//  RUNAInterstitialAd.h
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/08.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RUNABanner.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 @enum Enumerations of the size scale option
 */
typedef NS_ENUM(NSUInteger, RUNAInterstitialAdSize) {
    /// scale the ad content to fit screen size while keeping aspect ratio.
    RUNAInterstitialAdSizeAspectFit,
    /// show original size of ad content without scale.
    RUNAInterstitialAdSizeOriginal,
    /// no indicated size, work with RUNAInterstitialAdCustomDecorator  for customize purpose.
    RUNAInterstitialAdSizeCustom,
};

typedef void* _Nonnull (^RUNAInterstitialAdCustomDecorator)(UIView* containerView, UIView* bannerView);

@interface RUNAInterstitialAd : NSObject

#pragma mark - properties
/// unique id from admin site, required when `adSpotCode` is nil.
@property(nonatomic, copy, nullable) NSString* adSpotId;
/// unique code from admin site, required when `adSpotId` is nil.
@property(nonatomic, copy, nullable) NSString* adSpotCode;

/// the size scale option
@property(nonatomic) RUNAInterstitialAdSize size;
/// A callback block to customize the interstitial ad view.
@property(nonatomic, copy, nullable) RUNAInterstitialAdCustomDecorator decorator;
/// to replace the default image of the close button.
@property(nonatomic, nullable) UIImage* preferredCloseButtonImage;

/// direct url when ad is clicked
@property(nonatomic, readonly, nullable) NSString* clickURL;
/// prevent opening URL in system browser as default action when clicking
@property(nonatomic) BOOL shouldPreventDefaultClickAction;

/// aditional info
@property(nonatomic, nullable) NSDictionary* properties;

/// result of loading, true for succeeded
@property(nonatomic, readonly) BOOL loadSucceeded;

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
