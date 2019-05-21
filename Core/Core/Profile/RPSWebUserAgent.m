//
//  RPSWebUserAgent.m
//  RsspSDK
//
//  Created by Wu Wei on 2018/08/01.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RPSWebUserAgent.h"
#import <WebKit/WebKit.h>

@implementation RPSWebUserAgent {
    dispatch_semaphore_t _semaphore;
    WKWebView *webView;
}

-(void)asyncRequest {
    if (self.userAgent) {
        return;
    }
    
    RPSDebug("async request User-Agent...");
    _semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self getUserAgent];
    });
}

-(void)syncResult {
    RPSDebug("trace");
    if (NSThread.currentThread.isMainThread) {
        RPSDebug("Must not call this method in main thread.");
        return;
    }
    
    if (self.userAgent) {
        return;
    }
    
    if (_semaphore) {
        dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeout * NSEC_PER_SEC));
        RPSDebug("waiting on user-agent thread");
        dispatch_semaphore_wait(_semaphore, timeout);
        RPSDebug("waking up user-agent thread");
    }
}

-(void) getUserAgent {
    RPSDebug("get UserAgent by WKWebView");
    webView = [WKWebView new];
    [webView loadHTMLString:@"<html></html>" baseURL:nil];
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id __nullable userAgent, NSError * __nullable error) {
        RPSDebug("get UserAgent in %@ thread [%@]", NSThread.currentThread.isMainThread?@"Main":@"BG", userAgent);
        self->_userAgent = userAgent;
        if (self->_semaphore) {
            dispatch_semaphore_signal(self->_semaphore);
        }
    }];
}


@end
