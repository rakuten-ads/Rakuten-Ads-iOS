//
//  AdWebView.m
//  RUNASDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RUNAAdWebView.h"

@implementation RUNAAdWebView {
    NSMutableDictionary<NSString*, RUNAAdWebViewMessageHandler*>* _messageHandlers;
}

@synthesize messageHandlers = _messageHandlers;

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setScalesPageToFit];
        [self setBackgroundColor:UIColor.clearColor];
        [self setOpaque:NO];
        [self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self setAllowsLinkPreview:NO];

        for (UIView* subView in self.subviews) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView*)subView).scrollEnabled = false;
                ((UIScrollView*)subView).bounces = false;
                if (@available(iOS 11.0, *)) {
                    // Avoid HTML content fix position when scrolling
                    ((UIScrollView*)subView).contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                }
            }
        }
    }
    return self;
}

NSString *jScriptViewport =
@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1.0');"
@"document.getElementsByTagName('head')[0].appendChild(meta);"
@"document.getElementsByTagName('body')[0].style.margin = 0;";

- (void)setScalesPageToFit {
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jScriptViewport injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.configuration.userContentController addUserScript:userScript];
}

NSString *kSdkMessageHandlerName = @"runaSdkInterface";
-(void)addMessageHandler:(RUNAAdWebViewMessageHandler *)handler {
    if (!self.messageHandlers) {
        [self.configuration.userContentController addScriptMessageHandler:self name:kSdkMessageHandlerName];
        self->_messageHandlers = [NSMutableDictionary dictionary];
    }
    [self->_messageHandlers setObject:handler forKey:handler.type];
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    RUNADebug("received posted raw message name %@: %@", [message name], [message body]);
    if ([message.name isEqualToString:kSdkMessageHandlerName]
        && message.body) {
        @try {
            if ([message.body isKindOfClass:[NSDictionary class]]) {
                RUNAAdWebViewMessage* sdkMessage = [RUNAAdWebViewMessage parse:(NSDictionary*)message.body];
                RUNADebug("translate to sdk message %@", sdkMessage);
                RUNAAdWebViewMessageHandler* handler = self.messageHandlers[sdkMessage.type];
                if (handler) {
                    handler.handle(sdkMessage);
                }
                // PoC
                if ([sdkMessage.type isEqual:@"video_loaded"]) {
                    [self evaluateJavaScript:@"window.cd.sendViewable(true)" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                        RUNADebug("sendViewable: %@", result);
                    }];
                }
            }
        } @catch (NSException *exception) {
            RUNADebug("exception when waiting post message: %@", exception);
            RUNAAdWebViewMessageHandler* handler = self.messageHandlers[kSdkMessageTypeOther];
            if (handler) {
                handler.handle(nil);
            }
        }
    }
}

@end
