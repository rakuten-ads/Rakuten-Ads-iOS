//
//  AdWebView.h
//  RUNASDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "RUNAAdWebViewMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNAAdWebView : WKWebView <WKScriptMessageHandler>

@property(nonatomic,readonly) NSDictionary<NSString*, RUNAAdWebViewMessageHandler*>* messageHandlers;

- (void)addMessageHandler:(RUNAAdWebViewMessageHandler*) handler;
- (void)playVideo:(void (^)(void))completionHandler;
- (void)pauseVideo:(void (^)(void))completionHandler;

@end

NS_ASSUME_NONNULL_END
