//
//  RUNAInterstitialAd.m
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/08.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import "RUNAInterstitialAdInner.h"

@implementation RUNAInterstitialAd

-(void)loadWithEventHandler:(void (^)(RUNAInterstitialAd * _Nonnull, struct RUNABannerViewEvent))handler {
    if (self.loadSucceeded) {
        NSLog(@"[RUNA] interstitial ad has loaded already. Try a new RUNAInterstitialAd instance.");
        return;
    }
    self.eventHandler = handler;

    RUNABannerView* bannerView = [RUNABannerView new];
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    bannerView.size = RUNABannerViewSizeCustom;

    bannerView.adSpotId = self.adSpotId;
    bannerView.adSpotCode = self.adSpotCode;
    bannerView.properties = self.properties;
    bannerView.shouldPreventDefaultClickAction = self.shouldPreventDefaultClickAction;

    self->_bannerView = bannerView;
    __weak typeof(self) weakSelf = self;
    [bannerView loadWithEventHandler:^(RUNABannerView * _Nonnull banner, struct RUNABannerViewEvent event) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        switch (event.eventType) {
            case RUNABannerViewEventTypeSucceeded:
                strongSelf->_loadSucceeded = YES;
                break;
            case RUNABannerViewEventTypeClicked:
                strongSelf->_clickURL = banner.clickURL;
                break;
            case RUNABannerViewEventTypeInterstitialClosed:
                [strongSelf close];
                break;
            default:
                break;
        }

        strongSelf.eventHandler(strongSelf, event);
    }];
}

-(void)showIn:(UIViewController*) parentViewController {
    if (self.loadSucceeded) {
        // show viewcontroller
        self->_viewController = [RUNAInterstitalViewController new];
        self.viewController.bannerView = self.bannerView;
        self.viewController.interstitialAd = self;
        self.viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        if (@available(iOS 13.0, *)) {
            [self.viewController setModalInPresentation:NO];
        }
        [parentViewController presentViewController:self.viewController animated:NO completion:nil];
    } else {
        NSLog(@"[RUNA] interstitial ad content is not ready, try again later.");
    }
}

-(void)close {
    if (self.viewController) {
        [self.viewController dismissViewControllerAnimated:NO completion:nil];
    }
}

# pragma mark - preferredCloseButtonImage
static UIImage* _preferredCloseButtonImage;

+(void)setPreferredCloseButtonImage:(UIImage *)image {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _preferredCloseButtonImage = image;
    });
}

+(UIImage *)preferredCloseButtonImage {
    return _preferredCloseButtonImage;
}

@end
