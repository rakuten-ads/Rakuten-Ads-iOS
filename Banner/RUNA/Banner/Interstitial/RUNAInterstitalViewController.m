//
//  RUNAInterstitalViewController.m
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/08.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import "RUNAInterstitalViewController.h"
#import "RUNABannerViewInner.h"
#import "RUNAInterstitialAdInner.h"

@interface RUNAInterstitalViewController ()

@property (nonatomic) NSMutableArray<NSLayoutConstraint*>* bannerConstraints;

@end

@implementation RUNAInterstitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.bannerView) {
        self.view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
        [self.view addSubview:self.bannerView];
        [self.view addConstraints:@[
            [self.bannerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
            [self.bannerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        ]];
        [self.bannerView addConstraint:[self.bannerView.heightAnchor
                                        constraintEqualToAnchor:self.bannerView.widthAnchor
                                        multiplier:(self.bannerView.banner.height / self.bannerView.banner.width)
                                        constant:0.5]];

        [self resizeBannerView:self.view.frame.size];

        UIView* closeButton = [self closeButton];
        [self.view addSubview:closeButton];
        if (@available(iOS 11.0, *)) {
            [self.view addConstraints:@[
                [closeButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:8],
                [closeButton.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-8],
            ]];
        } else {
            [self.view addConstraints:@[
                [closeButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:8],
                [closeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8],
            ]];
        }
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

//    [self resizeBannerView:self.view.frame.size];
}

- (UIView*) closeButton {

    CGSize buttonSize = CGSizeMake(32, 32);

    UIImageView* closeImageView = [[UIImageView alloc] init];
    closeImageView.userInteractionEnabled = YES;
    closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [closeImageView addConstraints:@[
        [closeImageView.widthAnchor constraintEqualToConstant:buttonSize.width],
        [closeImageView.heightAnchor constraintEqualToConstant:buttonSize.height],
    ]];
    UIImage* buttonImage = RUNAInterstitialAd.preferredCloseButtonImage;
    if (!buttonImage) {
        UIImage* image = [UIImage imageNamed:@"close" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        buttonImage = image; // FIXME: use systemImage "xmark.circle" after support version lifts to iOS 13
    }
    closeImageView.image = buttonImage;
    closeImageView.tintColor = [UIColor.whiteColor colorWithAlphaComponent:0.9];

    UIGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onCloseButtonClicked:)];
    [closeImageView addGestureRecognizer:gesture];

    return closeImageView;
}

-(void) onCloseButtonClicked:(id) sender {
    RUNADebug("[RUNAInterstitial] onCloseButtonClicked");
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        RUNADebug("[RUNAInterstitial] ViewController dismissed");
        RUNAInterstitialAd* interstitialAd = weakSelf.interstitialAd;
        struct RUNABannerViewEvent event = { RUNABannerViewEventTypeInterstitialClosed, RUNABannerViewErrorNone };
        interstitialAd.eventHandler(interstitialAd, event);
    }];
}

- (void)resizeBannerView:(CGSize) containerSize {
    if (self.bannerView) {
        RUNADebug("[RUNAInterstitial] resize banner");
        [self.view removeConstraints:self.bannerConstraints];
        self.bannerConstraints = [NSMutableArray new];

        float ratioBanner = self.bannerView.banner.width / self.bannerView.banner.height;
        float ratioContainer = containerSize.width / containerSize.height;

        if (ratioBanner > ratioContainer) {
            // make banner width match container
            [self.bannerConstraints addObject:
                [self.bannerView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor]
            ];
        } else {
            // make banner height match container
            [self.bannerConstraints addObject:
                 [self.bannerView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor]
            ];
        }

        [self.view addConstraints:self.bannerConstraints];
    }
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//
//    RUNADebug("[Interstitial] viewWillTransitionToSize(%@)", NSStringFromCGSize(size));
//    [self resizeBannerView:size];
//}

@end
