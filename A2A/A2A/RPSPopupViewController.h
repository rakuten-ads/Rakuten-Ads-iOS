//
//  RPSPopupViewController.h
//  A2A
//
//  Created by Wu, Wei b on 2019/12/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSAdWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPSPopupViewController : UIViewController

@property (nonatomic) NSURL* url;
@property (nonatomic) RPSAdWebView* adWebView;

@property (weak, nonatomic) IBOutlet UIView *adWebViewContainerView;


@end

NS_ASSUME_NONNULL_END
