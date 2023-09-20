//
//  AdWebView.m
//  RUNASDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RUNAAdWebView.h"

@implementation RUNAAdWebView

-(instancetype)initWithFrame:(CGRect)frame {
    WKWebViewConfiguration* config = [WKWebViewConfiguration new];
    config.allowsInlineMediaPlayback = YES;
    self = [super initWithFrame:frame configuration:config];
    return self;
}

- (void)adjustAppearance {
    [self setScalesPageToFit];
    [self setBackgroundColor:UIColor.clearColor];
    [self setOpaque:NO];
    [self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self setAllowsLinkPreview:NO];
#if DEBUG
    if (@available(iOS 16.4, *)) {
        self.inspectable = YES;
    }
#endif

    self.scrollView.scrollEnabled = NO;
    self.scrollView.bounces = NO;
    // Avoid HTML content fix position when scrolling
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

NSString *jScriptViewport =
@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1.0');"
@"document.getElementsByTagName('head')[0].appendChild(meta);"
@"document.getElementsByTagName('body')[0].style.margin = 0;"
@"document.getElementsByTagName('body')[0].style.webkitTouchCallout='none';"
@"document.getElementsByTagName('body')[0].style.webkitUserSelect='none';"
@"";

NSString *jScriptMargin =
@"document.getElementsByTagName('body')[0].style.marginLeft = 0.3;"
@"document.getElementsByTagName('body')[0].style.marginRight = 0.3;"
@"";


- (void)setScalesPageToFit {
    NSString* jscript = jScriptViewport;
    if (self.isSafeForBorder) {
        jscript = [jscript stringByAppendingString:jScriptMargin];
    }

    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jscript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.configuration.userContentController addUserScript:userScript];
}

@end
