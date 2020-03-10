//
//  RUNAPopupViewController.h
//  A2A
//
//  Created by Wu, Wei b on 2019/12/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUNAAdWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNAPopupViewController : UIViewController

@property (nonatomic) NSURL* url;
@property (nonatomic) RUNAAdWebView* adWebView;

@property (weak, nonatomic) IBOutlet UIView *adWebViewContainerView;


@end

NS_ASSUME_NONNULL_END
