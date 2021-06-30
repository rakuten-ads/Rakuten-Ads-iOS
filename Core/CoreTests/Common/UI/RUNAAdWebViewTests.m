//
//  RUNAAdWebViewTests.m
//  CoreTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/30.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAAdWebView.h"

@interface RUNAAdWebViewTests : XCTestCase
@end

@implementation RUNAAdWebViewTests

- (void)testInit {
    RUNAAdWebView *webView = [[RUNAAdWebView alloc]initWithFrame:CGRectZero];
    XCTAssertTrue(webView.configuration.allowsInlineMediaPlayback);
    XCTAssertEqual(webView.backgroundColor, UIColor.clearColor);
    XCTAssertFalse(webView.opaque);
    XCTAssertEqual(webView.autoresizingMask, UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    XCTAssertFalse(webView.allowsLinkPreview);
    XCTAssertFalse(webView.scrollView.scrollEnabled);
    XCTAssertFalse(webView.scrollView.bounces);
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        XCTAssertEqual(webView.scrollView.contentInsetAdjustmentBehavior, UIScrollViewContentInsetAdjustmentNever);
    }
}

@end
