//
//  RPSPopupViewController.m
//  RDN
//
//  Created by Wu, Wei b on 2019/12/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSPopupViewController.h"

@implementation RPSPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.url) {
        [self.adWebView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}

- (IBAction)onExit:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
