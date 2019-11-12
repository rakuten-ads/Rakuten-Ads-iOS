//
//  AdWebView.m
//  RPSSDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RPSAdWebView.h"

@implementation RPSAdWebView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setScalesPageToFit];
        [self setBackgroundColor:UIColor.clearColor];
        [self setOpaque:NO];

        for (UIView* subView in self.subviews) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView*)subView).scrollEnabled = false;
                ((UIScrollView*)subView).bounces = false;
            }
        }
    }
    return self;
}

NSString *jScriptViewport =
@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width');"
@"document.getElementsByTagName('head')[0].appendChild(meta);"
@"document.getElementsByTagName('body')[0].style.margin = 0;";

- (void)setScalesPageToFit {
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jScriptViewport injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.configuration.userContentController addUserScript:userScript];
}

@end
