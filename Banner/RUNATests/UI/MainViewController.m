//
//  MainViewController.m
//  Banner
//
//  Created by Sato, Akihiko | Akkie on 2021/05/21.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "MainViewController.h"

const CGFloat kBannerHeight = 50.f;
const CGFloat kBannerWidth = 200.f;

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerView = [[RUNABannerView alloc]initWithFrame:CGRectMake(0, 0, kBannerWidth, kBannerHeight)];
    [self.view addSubview:self.bannerView];
}

@end
