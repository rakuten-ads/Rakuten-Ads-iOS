//
//  RUNAWebUserAgent.m
//  RsspSDK
//
//  Created by Wu Wei on 2018/08/01.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RUNAWebUserAgent.h"
#import <WebKit/WebKit.h>

@implementation RUNAWebUserAgent {
    dispatch_semaphore_t _semaphore;
    WKWebView *webView;
}

-(void)asyncRequest {
    if (self.userAgent) {
        return;
    }
    
    RUNADebug("async request User-Agent...");
    _semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self getUserAgent];
    });
}

-(void)syncResult {
    if (NSThread.currentThread.isMainThread) {
        RUNADebug("Must not call this method in main thread.");
        return;
    }

    @synchronized (self) {
        if (self.userAgent) {
            return;
        }

        if (_semaphore) {
            dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeout * NSEC_PER_SEC));
            RUNADebug("waiting on user-agent thread");
            dispatch_semaphore_wait(_semaphore, timeout);
            RUNADebug("waking up user-agent thread");
        }
    }
}

-(void) getUserAgent {
    RUNADebug("get UserAgent by WKWebView");
    webView = [WKWebView new];
    [webView loadHTMLString:@"<html></html>" baseURL:nil];
    __weak RUNAWebUserAgent* weakSelf = self;
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id __nullable userAgent, NSError * __nullable error) {
        RUNADebug("get UserAgent in %@ thread [%@]", NSThread.currentThread.isMainThread?@"Main":@"BG", userAgent);
        __strong RUNAWebUserAgent* blockSelf = weakSelf;
        blockSelf->_userAgent = userAgent;
        blockSelf->webView = nil;
        if (blockSelf->_semaphore) {
            dispatch_semaphore_signal(blockSelf->_semaphore);
        }
    }];
}


@end
