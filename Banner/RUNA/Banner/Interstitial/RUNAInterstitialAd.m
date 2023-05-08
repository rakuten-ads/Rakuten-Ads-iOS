//
//  RUNAInterstitialAd.m
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/08.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import "RUNAInterstitialAdInner.h"

@implementation RUNAInterstitialAd

-(void)preloadWithEventHandler:(void (^)(RUNAInterstitialAd * _Nonnull, struct RUNABannerViewEvent))handler {
    if (self.loadSucceeded) {
        NSLog(@"[RUNA] interstitial ad has loaded already. Try a new RUNAInterstitialAd instance.");
        return;
    }
    self.eventHandler = handler;

    if (!self.adContentView) {
        self.adContentView = [RUNABannerView new];
        self.adContentView.adSpotId = self.adSpotId;
        self.adContentView.adSpotCode = self.adSpotCode;
    }

    self.adContentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.adContentView.size = RUNABannerViewSizeCustom;
    self.adContentView.position = RUNABannerViewPositionCustom;
    self.adContentView.imp.isInterstitial = YES;

    __weak typeof(self) weakSelf = self;
    [self.adContentView loadWithEventHandler:^(RUNABannerView * _Nonnull banner, struct RUNABannerViewEvent event) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        switch (event.eventType) {
            case RUNABannerViewEventTypeSucceeded:
                strongSelf->_loadSucceeded = YES;
                break;
            case RUNABannerViewEventTypeInterstitialClosed:
                [strongSelf close];
                break;
            default:
                break;
        }
        if (strongSelf.eventHandler) {
            strongSelf.eventHandler(strongSelf, event);
        }
    }];
}

-(BOOL)showIn:(UIViewController*) parentViewController {
    if (self.loadSucceeded) {
        // show viewcontroller
        self->_viewController = [RUNAInterstitialViewController new];
        self.viewController.bannerView = self.adContentView;
        self.viewController.interstitialAd = self;
        self.viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self.viewController setModalInPresentation:NO];
        [parentViewController presentViewController:self.viewController animated:NO completion:nil];
        return YES;
    } else {
        NSLog(@"[RUNA] interstitial ad content is not ready, try again later.");
    }
    return NO;
}

-(void)close {
    if (self.viewController) {
        [self.viewController dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
