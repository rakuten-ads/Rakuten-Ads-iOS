//
//  RUNAPopupViewController.m
//  A2A
//
//  Created by Wu, Wei b on 2019/12/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNAPopupViewController.h"

@interface RUNAPopupViewController() <WKNavigationDelegate>

@end

@implementation RUNAPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.url) {
        self.adWebView = [WKWebView new];
        self.adWebView.navigationDelegate = self;
        [self.adWebViewContainerView addSubview:self.adWebView];
        
        self.adWebView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.adWebView.leadingAnchor constraintEqualToAnchor:self.adWebViewContainerView.leadingAnchor],
            [self.adWebView.topAnchor constraintEqualToAnchor:self.adWebViewContainerView.topAnchor],
            [self.adWebView.trailingAnchor constraintEqualToAnchor:self.adWebViewContainerView.trailingAnchor],
            [self.adWebView.bottomAnchor constraintEqualToAnchor:self.adWebViewContainerView.bottomAnchor],
        ]];

        [self.adWebView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}

- (IBAction)onExit:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    RUNADebug("webview navigation type %@ decide for: %@",
              navigationAction.navigationType == WKNavigationTypeLinkActivated ? @"WKNavigationTypeLinkActivated" :
              navigationAction.navigationType == WKNavigationTypeOther ? @"WKNavigationTypeOther" :
              navigationAction.navigationType == WKNavigationTypeReload ? @"WKNavigationTypeReload" :
              navigationAction.navigationType == WKNavigationTypeBackForward ? @"WKNavigationTypeBackForward" :
              navigationAction.navigationType == WKNavigationTypeFormSubmitted ? @"WKNavigationTypeFormSubmitted" :
              navigationAction.navigationType == WKNavigationTypeFormResubmitted ? @"WKNavigationTypeFormResubmitted" :
              @"unknown"
              , navigationAction.request.URL.absoluteString);
    
    NSURL* url = navigationAction.request.URL;
    if (url && navigationAction.targetFrame.isMainFrame) {
        if (navigationAction.navigationType == WKNavigationTypeLinkActivated // alternative 1 : click link
            || (navigationAction.navigationType == WKNavigationTypeOther // alternative 2: location change except internal Base URL
                && ![url.absoluteString isEqualToString:self.url.absoluteString])
            ) {
            RUNADebug("clicked ad");
            [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success){
                RUNADebug("opened AD URL");
            }];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }

    RUNADebug("WKNavigationActionPolicyAllow");
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
