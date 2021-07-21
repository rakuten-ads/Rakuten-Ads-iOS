//
//  MainViewController.h
//  Banner
//
//  Created by Sato, Akihiko | Akkie on 2021/05/21.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUNABannerView.h"

extern const CGFloat kBannerHeight;
extern const CGFloat kBannerWidth;

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController
@property (nonatomic) RUNABannerView *bannerView;
@end

NS_ASSUME_NONNULL_END
