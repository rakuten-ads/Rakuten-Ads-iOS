//
//  RUNAInterstitalViewController.h
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/08.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUNABannerView.h"
#import "RUNAInterstitialAd.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNAInterstitialViewController : UIViewController

@property(nonatomic) RUNABannerView* bannerView;
@property(nonatomic, weak) RUNAInterstitialAd* interstitialAd;
@property(nonatomic, readonly) UIImageView* closeButton;

@end

NS_ASSUME_NONNULL_END
