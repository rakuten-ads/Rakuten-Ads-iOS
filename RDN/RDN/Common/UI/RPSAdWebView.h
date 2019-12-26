//
//  AdWebView.h
//  RPSSDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "RPSAdWebViewMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPSAdWebView : WKWebView <WKScriptMessageHandler>

@property(nonatomic,readonly) NSDictionary<NSString*, RPSAdWebViewMessageHandler*>* messageHandlers;

-(void) addMessageHandler:(RPSAdWebViewMessageHandler*) handler;

@end

NS_ASSUME_NONNULL_END
