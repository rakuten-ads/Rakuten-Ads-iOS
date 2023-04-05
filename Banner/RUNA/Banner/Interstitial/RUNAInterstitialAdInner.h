//
//  RUNAInterstitialAdInner.h
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/08.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#ifndef RUNAInterstitialAdInner_h
#define RUNAInterstitialAdInner_h

#import "RUNAInterstitialAd.h"
#import "RUNAInterstitialViewController.h"
#import "RUNABannerViewInner.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^RUNAInterstitialEventHandler)(RUNAInterstitialAd* view, struct RUNABannerViewEvent event);

@interface RUNAInterstitialAd ()

@property(nonatomic, nullable, copy) RUNAInterstitialEventHandler eventHandler;

@property(nonatomic, readonly, nullable) RUNAInterstitialViewController* viewController;

@end
NS_ASSUME_NONNULL_END

#endif /* RUNAInterstitialAdInner_h */
