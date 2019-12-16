//
//  AdWebView.m
//  RPSSDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RPSAdWebView.h"

@implementation RPSAdWebView {
    NSMutableArray<RPSAdWebViewMessageHandler*>* _messageHandlers;
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

-(void)addMessageHandler:(RPSAdWebViewMessageHandler *)handler {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.configuration.userContentController addScriptMessageHandler:self name:kSdkMessageHandlerName];
        self->_messageHandlers = [NSMutableArray array];
    });
    [self->_messageHandlers addObject:handler];
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    RPSDebug("received posted message %@", [message debugDescription]);

    if ([message.name isEqualToString:kSdkMessageHandlerName]
        && message.body) {
        @try {
            if ([message.body isKindOfClass:[NSDictionary class]]) {
                RPSAdWebViewMessage* sdkMessage = [RPSAdWebViewMessage parse:(NSDictionary*)message.body];
                RPSDebug("sdk message %@", sdkMessage);
                [self.messageHandlers enumerateObjectsUsingBlock:^(RPSAdWebViewMessageHandler * _Nonnull messageHandler, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([sdkMessage.type isEqualToString:messageHandler.type]) {
                        messageHandler.handle(sdkMessage);
                        *stop = YES;
                    }
                }];
            }
        } @catch (NSException *exception) {
            RPSDebug("exception when waiting post message: %@", exception);
            [self.messageHandlers enumerateObjectsUsingBlock:^(RPSAdWebViewMessageHandler * _Nonnull messageHandler, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([kSdkMessageTypeOther isEqualToString:messageHandler.type]) {
                    messageHandler.handle(nil);
                    *stop = YES;
                }
            }];
        }
    }
}

@end
