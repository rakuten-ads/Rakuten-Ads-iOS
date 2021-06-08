//
//  RUNAAdWebViewMessageManager.m
//  Core
//
//  Created by Wu, Wei | David on 2021/06/08.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNAAdWebViewMessageManager.h"

@implementation RUNAAdWebViewMessageManager

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        self->_name = name;
        self->_messageHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)addMessageHandler:(RUNAAdWebViewMessageHandler *)handler {
//        [self.configuration.userContentController addScriptMessageHandler:self name:kSdkMessageHandlerName];
    [self->_messageHandlers setObject:handler forKey:handler.type];
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    RUNADebug("received posted raw message name %@: %@", [message name], [message body]);
    if ([message.name isEqualToString:self.name]
        && message.body) {
        @try {
            if ([message.body isKindOfClass:[NSDictionary class]]) {
                RUNAAdWebViewMessage* sdkMessage = [RUNAAdWebViewMessage parse:(NSDictionary*)message.body];
                RUNADebug("translate to sdk message %@", sdkMessage);
                RUNAAdWebViewMessageHandler* handler = self.messageHandlers[sdkMessage.type];
                if (handler) {
                    handler.handle(sdkMessage);
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
