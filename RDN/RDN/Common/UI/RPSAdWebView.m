//
//  AdWebView.m
//  RPSSDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RPSAdWebView.h"

@implementation RPSAdWebView {
    NSMutableDictionary<NSString*, RPSAdWebViewMessageHandler*>* _messageHandlers;
}

@synthesize messageHandlers = _messageHandlers;

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

NSString *kSdkMessageHandlerName = @"rpsSdkInterface";
-(void)addMessageHandler:(RPSAdWebViewMessageHandler *)handler {
    if (!self.messageHandlers) {
        [self.configuration.userContentController addScriptMessageHandler:self name:kSdkMessageHandlerName];
        self->_messageHandlers = [NSMutableDictionary dictionary];
    }
    [self->_messageHandlers setObject:handler forKey:handler.type];
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    RPSDebug("received posted raw message %@", [message debugDescription]);
    if ([message.name isEqualToString:kSdkMessageHandlerName]
        && message.body) {
        @try {
            if ([message.body isKindOfClass:[NSDictionary class]]) {
                RPSAdWebViewMessage* sdkMessage = [RPSAdWebViewMessage parse:(NSDictionary*)message.body];
                RPSDebug("translate to sdk message %@", sdkMessage);
                RPSAdWebViewMessageHandler* handler = self.messageHandlers[sdkMessage.type];
                if (handler) {
                    handler.handle(sdkMessage);
                }
            }
        } @catch (NSException *exception) {
            RPSDebug("exception when waiting post message: %@", exception);
            RPSAdWebViewMessageHandler* handler = self.messageHandlers[kSdkMessageTypeOther];
            if (handler) {
                handler.handle(nil);
            }
        }
    }
}

@end
