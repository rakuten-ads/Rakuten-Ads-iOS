//
//  RUNAInterstitalViewController.m
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/08.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import "RUNAInterstitialViewController.h"
#import "RUNABannerViewInner.h"
#import "RUNAInterstitialAdInner.h"

@interface RUNAInterstitialViewController ()

@property (nonatomic) NSMutableArray<NSLayoutConstraint*>* containerViewConstraints;
@property (nonatomic) NSMutableArray<NSLayoutConstraint*>* bannerViewConstraints;

@end

@implementation RUNAInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.bannerView) {
        self.view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
        [self.bannerView addConstraint:[self.bannerView.heightAnchor
                                        constraintEqualToAnchor:self.bannerView.widthAnchor
                                        multiplier:(self.bannerView.banner.height / self.bannerView.banner.width)
                                        constant:0.5]];

        switch (self.interstitialAd.size) {
            case RUNAInterstitialAdSizeAspectFit:
                [self applySizeAspectFit:self.view.frame.size];
                break;
            case RUNAInterstitialAdSizeOriginal:
                [self applySizeOriginal];
                break;
            case RUNAInterstitialAdSizeCustom:
                RUNADebug("[RUNAInterstitial] applySize Custom");
                if (self.interstitialAd.decorator) {
                    RUNADebug("[RUNAInterstitial] apply decorator");
                    self.interstitialAd.decorator(self.view, self.bannerView);
                    if (!self.bannerView.superview) {
                        [self.view addSubview:self.bannerView];
                    }
                }
                break;
            default:
                RUNADebug("[RUNAInterstitial] unsupported size mode %lu", (unsigned long)self.interstitialAd.size);
                break;
        }
    }
    [self addCloseButton];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    RUNADebug("[RUNAInterstitial] viewWillTransitionToSize %@", NSStringFromCGSize(size));
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    if (self.interstitialAd.size == RUNAInterstitialAdSizeAspectFit) {
        [self applySizeAspectFit:size];
        [self.view layoutIfNeeded];
    }
}

#pragma mark - resize
- (void)applySizeAspectFit:(CGSize) containerSize {
    RUNADebug("[RUNAInterstitial] applySizeAspectFit");
    if (self.bannerView.superview) {
        RUNADebug("[RUNAInterstitial] has superview");
        [self.bannerView removeFromSuperview];
    }
    [self.view addSubview:self.bannerView];

    if (self.containerViewConstraints) {
        [self.view removeConstraints:self.containerViewConstraints];
    }

    self.containerViewConstraints = [NSMutableArray new];
    [self.containerViewConstraints addObjectsFromArray:@[
        [self.bannerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.bannerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];

    float ratioBanner = self.bannerView.banner.width / self.bannerView.banner.height;
    float ratioContainer = containerSize.width / containerSize.height;

    if (ratioBanner > ratioContainer) {
        // make banner width match container
        [self.containerViewConstraints addObject:
             [self.bannerView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor]
        ];
    } else {
        // make banner height match container
        [self.containerViewConstraints addObject:
             [self.bannerView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor]
        ];
    }

    [self.view addConstraints:self.containerViewConstraints];
}

-(void) applySizeOriginal {
    RUNADebug("[RUNAInterstitial] applySizeOriginal");
    if (self.bannerView.superview) {
        RUNADebug("[RUNAInterstitial] has superview");
        [self.bannerView removeFromSuperview];
    }
    [self.view addSubview:self.bannerView];

    // config container view
    if (self.containerViewConstraints) {
        [self.view removeConstraints:self.containerViewConstraints];
    }

    self.containerViewConstraints = [NSMutableArray new];
    [self.containerViewConstraints addObjectsFromArray:@[
        [self.bannerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.bannerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    ]];
    [self.view addConstraints:self.containerViewConstraints];

    // config banner view
    if (self.bannerViewConstraints) {
        [self.bannerView removeConstraints:self.bannerViewConstraints];
    }

    self.bannerViewConstraints = [NSMutableArray new];
    CGSize originalBannerSize = CGSizeMake(self.bannerView.banner.width, self.bannerView.banner.height);
    [self.bannerViewConstraints addObjectsFromArray:@[
        [self.bannerView.widthAnchor constraintEqualToConstant:originalBannerSize.width],
        [self.bannerView.heightAnchor constraintEqualToConstant:originalBannerSize.height],
    ]];
    [self.bannerView addConstraints:self.bannerViewConstraints];
}

#pragma mark - close button
- (void)addCloseButton {
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

- (UIView*)closeButton {
    CGSize buttonSize = CGSizeMake(32, 32);

    UIImageView* closeImageView = [[UIImageView alloc] init];
    closeImageView.userInteractionEnabled = YES;
    closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [closeImageView addConstraints:@[
        [closeImageView.widthAnchor constraintEqualToConstant:buttonSize.width],
        [closeImageView.heightAnchor constraintEqualToConstant:buttonSize.height],
    ]];
    UIImage* buttonImage = self.interstitialAd.preferredCloseButtonImage;
    if (!buttonImage) {
        buttonImage = [UIImage imageNamed:@"close" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    }
    closeImageView.image = buttonImage;
    closeImageView.tintColor = [UIColor.whiteColor colorWithAlphaComponent:0.9];

    UIGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onCloseButtonClicked:)];
    [closeImageView addGestureRecognizer:gesture];

    return closeImageView;
}

- (void)onCloseButtonClicked:(id) sender {
    RUNADebug("[RUNAInterstitial] onCloseButtonClicked");
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        RUNADebug("[RUNAInterstitial] ViewController dismissed");
        RUNAInterstitialAd* interstitialAd = weakSelf.interstitialAd;
        struct RUNABannerViewEvent event = { RUNABannerViewEventTypeInterstitialClosed, RUNABannerViewErrorNone };
        interstitialAd.eventHandler(interstitialAd, event);
    }];
}

@end
