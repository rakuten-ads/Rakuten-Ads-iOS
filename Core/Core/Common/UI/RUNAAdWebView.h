//
//  AdWebView.h
//  RUNASDK
//
//  Created by Wu Wei on 2018/07/23.
//  Update by Wu Wei on 2023/09/20
//  Copyright © 2018 LOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAAdWebView : WKWebView

/// True for keeping a margin to make sure all borders is showed completely.
@property BOOL isSafeForBorder;

/// adjust appearance for RUNA Webview content
- (void)adjustAppearance;

@end

NS_ASSUME_NONNULL_END
