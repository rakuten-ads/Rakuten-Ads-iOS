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

@interface RUNAInterstitialAd : NSObject

#pragma mark - properties
/// unique id from admin site, required when `adSpotCode` is nil.
@property(nonatomic, copy, nullable) NSString* adSpotId;
/// unique code from admin site, required when `adSpotId` is nil.
@property(nonatomic, copy, nullable) NSString* adSpotCode;

@property(nonatomic, nullable)UIImage* preferredCloseButtonImage;

/// direct url when ad is clicked
@property(nonatomic, readonly, nullable) NSString* clickURL;
/// prevent opening URL in system browser as default action when clicking
@property(nonatomic) BOOL shouldPreventDefaultClickAction;

/// aditional info
@property(nonatomic, nullable) NSDictionary* properties;

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
