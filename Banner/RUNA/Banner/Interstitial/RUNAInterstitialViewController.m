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

@property(nonatomic) NSMutableArray<NSLayoutConstraint*>* containerViewConstraints;
@property(nonatomic) NSMutableArray<NSLayoutConstraint*>* bannerViewConstraints;

@property(nonatomic) UIImageView* closeButton;

@end

@implementation RUNAInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addCloseButton];
    if (self.bannerView) {
        self.view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
        [self.bannerView addConstraint:[self.bannerView.heightAnchor
                                        constraintEqualToAnchor:self.bannerView.widthAnchor
                                        multiplier:(self.bannerView.designatedContentSize.height / self.bannerView.designatedContentSize.width)
                                        constant:0.5]];
        [self applySizeOption:self.view.frame.size];
    }

    [self.view bringSubviewToFront:self.closeButton];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    RUNADebug("[RUNAInterstitial] viewWillTransitionToSize %@", NSStringFromCGSize(size));
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    if (self.bannerView) {
        [self applySizeOption:size];

        [self.view bringSubviewToFront:self.closeButton];
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - apply size
- (void)applySizeOption:(CGSize) containerSize {
    switch (self.interstitialAd.size) {
        case RUNAInterstitialAdSizeAspectFit:
            [self applySizeAspectFit:containerSize];
            break;
        case RUNAInterstitialAdSizeOriginal:
            [self applySizeOriginal];
            break;
        case RUNAInterstitialAdSizeCustom:
            RUNADebug("[RUNAInterstitial] applySize Custom");
            if (self.interstitialAd.decorator) {
                [self applyDecoration];
            }
            break;
        default:
            RUNADebug("[RUNAInterstitial] unsupported size mode %lu", (unsigned long)self.interstitialAd.size);
            break;
    }
}

- (void)applySizeAspectFit:(CGSize) containerSize {
    RUNADebug("[RUNAInterstitial] applySizeAspectFit %@", NSStringFromCGSize(containerSize));
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

- (void)applyDecoration {
    RUNADebug("[RUNAInterstitial] apply decorator");
    self.interstitialAd.decorator(self.view, self.bannerView, self.closeButton);
    if (!self.bannerView.superview) {
        [self.view addSubview:self.bannerView];
    }
}

#pragma mark - close button
- (void)addCloseButton {
    self.closeButton = [self closeButtonView];
    [self.view addSubview:self.closeButton];
    [self.view addConstraints:@[
        [self.closeButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:8],
        [self.closeButton.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-8],
    ]];
}

- (UIImageView*)closeButtonView {
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
        // use default image
        buttonImage = [UIImage systemImageNamed:@"xmark.circle"];
        closeImageView.tintColor = [UIColor.whiteColor colorWithAlphaComponent:0.9];
    }
    closeImageView.image = buttonImage;

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
        if (interstitialAd.eventHandler) {
            struct RUNABannerViewEvent event = { RUNABannerViewEventTypeInterstitialClosed, RUNABannerViewErrorNone };
            interstitialAd.eventHandler(interstitialAd, event);
        }
    }];
}

@end
