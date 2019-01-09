//
//  GAPAdView.m
//  GAPSDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "GAPAdView.h"
#import "GAPAdWebView.h"
#import "GAPAdRequest.h"
#import <GAPCore/GAPValid.h>
#import "GAPDefines.h"

typedef BOOL (^GAPAdViewEventHandler)(GAPAdViewEvent event);

typedef NS_ENUM(NSUInteger, GAPAdViewState) {
    GAP_ADVIEW_STATE_INIT,
    GAP_ADVIEW_STATE_LOADING,
    GAP_ADVIEW_STATE_LOADED,
    GAP_ADVIEW_STATE_SHOWED,
    GAP_ADVIEW_STATE_FAILED,
    GAP_ADVIEW_STATE_CLICKED,
};

@interface GAPAdView() <GAPAdRequestDelegate, WKNavigationDelegate>

@property (nonatomic, nonnull) GAPAdWebView* webView;
@property (nonatomic, nullable, copy) GAPAdViewEventHandler eventHandler;
@property (nonatomic) GAPAdViewPosition position;
@property (nonatomic, assign, nullable) UIView* parentView;
@property (atomic) GAPAdViewState state;

@end

@implementation GAPAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        GAPTrace
        self.hidden = YES;
        self.state = GAP_ADVIEW_STATE_INIT;
    }
    return self;
}

@synthesize state = _state;

-(void)setState:(GAPAdViewState)state {
    GAPLog(@"set state %@",
           state == GAP_ADVIEW_STATE_INIT ? @"INIT" :
           state == GAP_ADVIEW_STATE_LOADING ? @"LOADING" :
           state == GAP_ADVIEW_STATE_LOADED ? @"LOADED" :
           state == GAP_ADVIEW_STATE_SHOWED ? @"SHOWED" :
           state == GAP_ADVIEW_STATE_FAILED ? @"FAILED" :
           state == GAP_ADVIEW_STATE_CLICKED ? @"CLICKED" : @"unknown");
    self->_state = state;
}

-(GAPAdViewState)state {
    return self->_state;
}

#pragma mark - APIs
-(void)show {
    [self showWithEventHandler:nil];
}

-(void) showWithEventHandler:(GAPAdViewEventHandler)handler {GAPTrace
    self.eventHandler = handler;
    dispatch_async(GAPDefines.sharedQueue, ^{
        @try {
            VERBOSE_LOG(@"%@", GAPDefines.sharedInstance);
            if ([GAPValid isEmptyString:self.adSpotId]) {
                NSLog(@"[RSSP] require adSpotId!");
                @throw [NSException exceptionWithName:@"init failed" reason:@"adSpotId is empty" userInfo:nil];
            }

            GAPAdRequest* request = [[GAPAdRequest alloc]initWithAdSpotId:self.adSpotId];
            request.delegate = self;
            [request resume];
            self.state = GAP_ADVIEW_STATE_LOADING;
        } @catch(NSException* exception) {
            VERBOSE_LOG(@"show exception: %@", exception);
            [self triggerFailure];
        }
    });
}

-(void)setPosition:(GAPAdViewPosition)position inView:(UIView *)parentView {
    if (!parentView) {
        VERBOSE_LOG(@"parent view cannot be nil");
        return;
    }

    self.position = position;
    self.parentView = parentView;
    if (self.state == GAP_ADVIEW_STATE_SHOWED) {
        GAPLog(@"re-apply position after showed");
        [self applyPosition];
    }
}

#pragma mark - UI frame control
-(void) applySize:(GAPAdSpotInfo*) adSpotInfo {
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            adSpotInfo.width,
                            adSpotInfo.height);
    GAPLog(@"apply size: %@", NSStringFromCGRect(self.frame));
}

-(void)applyPosition{
    if (self.parentView) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        if (![self.parentView.subviews containsObject:self]) {
            GAPLog(@"add as subview");
            [self.parentView addSubview:self];
        }
        if (@available(ios 11.0, *)) {
            [self applyPositionWithSafeArea];
        } else {
            [self applyPositionWithParentView];
        }
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.widthAnchor constraintEqualToConstant:CGRectGetWidth(self.frame)],
                                                  [self.heightAnchor constraintEqualToConstant:CGRectGetHeight(self.frame)],
                                                  ]];
        [self layoutIfNeeded];
        GAPLog(@"apply position %@", NSStringFromCGRect(self.frame));
    }
}

-(void)applyPositionWithSafeArea API_AVAILABLE(ios(11.0)){
    GAPTrace
    UILayoutGuide* safeGuide = self.parentView.safeAreaLayoutGuide;
    switch (self.position) {
        case GAP_ADVIEW_POSITION_TOP_LEFT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.leftAnchor constraintEqualToAnchor:safeGuide.leftAnchor],
                                                      [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                                      ]];
            break;
        case GAP_ADVIEW_POSITION_TOP:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.centerXAnchor constraintEqualToAnchor:safeGuide.centerXAnchor],
                                                      [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                                      ]];
            break;
        case GAP_ADVIEW_POSITION_TOP_RIGHT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.rightAnchor constraintEqualToAnchor:safeGuide.rightAnchor],
                                                      [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                                      ]];
            break;
        case GAP_ADVIEW_POSITION_BOTTOM_LEFT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.leftAnchor constraintEqualToAnchor:safeGuide.leftAnchor],
                                                      [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                                      ]];
            break;
        case GAP_ADVIEW_POSITION_BOTTOM_RIGHT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.rightAnchor constraintEqualToAnchor:safeGuide.rightAnchor],
                                                      [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                                      ]];
            break;
        case GAP_ADVIEW_POSITION_BOTTOM:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.centerXAnchor constraintEqualToAnchor:safeGuide.centerXAnchor],
                                                      [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                                      ]];
            break;
        default:
            ;
    }
}

-(void)applyPositionWithParentView {
    GAPTrace
    switch (self.position) {
        case GAP_ADVIEW_POSITION_TOP_LEFT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.topAnchor constraintEqualToAnchor:self.parentView.topAnchor],
                                                      [self.leftAnchor constraintEqualToAnchor:self.parentView.leftAnchor],
                                                      ]];
            break;
        case GAP_ADVIEW_POSITION_TOP:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.topAnchor constraintEqualToAnchor:self.parentView.topAnchor],
                                                      [self.centerXAnchor constraintEqualToAnchor:self.parentView.centerXAnchor],
                                                      ]];
            break;
        case GAP_ADVIEW_POSITION_TOP_RIGHT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.topAnchor constraintEqualToAnchor:self.parentView.topAnchor],
                                                      [self.rightAnchor constraintEqualToAnchor:self.parentView.rightAnchor],
                                                      ]];
            break;
        case GAP_ADVIEW_POSITION_BOTTOM_LEFT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.bottomAnchor constraintEqualToAnchor:self.parentView.bottomAnchor],
                                                      [self.leftAnchor constraintEqualToAnchor:self.parentView.leftAnchor],
                                                      ]];
            break;
        case GAP_ADVIEW_POSITION_BOTTOM_RIGHT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.bottomAnchor constraintEqualToAnchor:self.parentView.bottomAnchor],
                                                      [self.rightAnchor constraintEqualToAnchor:self.parentView.rightAnchor],
                                                      ]];
            break;
        case GAP_ADVIEW_POSITION_BOTTOM:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.bottomAnchor constraintEqualToAnchor:self.parentView.bottomAnchor],
                                                      [self.centerXAnchor constraintEqualToAnchor:self.parentView.centerXAnchor],
                                                      ]];
            break;
        default:
            ;
    }
}

-(void) applyView:(GAPAdSpotInfo*) adSpotInfo {
    GAPLog(@"apply applyView: %@", NSStringFromCGRect(self.frame));

    // Web View
    self.webView = [[GAPAdWebView alloc]initWithFrame:self.bounds];
    self.webView.navigationDelegate = self;
    [self addSubview:self.webView];
    [self.webView loadHTMLString:adSpotInfo.html baseURL:nil];
}

#pragma mark - implement GAPAdRequestDelegate

-(void)adRequestOnFailure {
    self.state = GAP_ADVIEW_STATE_LOADED;
    [self triggerFailure];
}

-(void)adRequestOnSuccess:(GAPAdSpotInfo *)adSpotInfo {
    @try {
        GAPLog(@"adRequestOnSuccess: %@", adSpotInfo);
        self.state = GAP_ADVIEW_STATE_LOADED;

        if (!adSpotInfo) {
            VERBOSE_LOG(@"AdSpotInfo is empty");
            @throw [NSException exceptionWithName:@"show failed" reason:@"adSpotInfo is empty" userInfo:@{@"GAPAdSpotInfo": [NSNull null]}];
        }

        if ([GAPValid isEmptyString:adSpotInfo.html]) {
            VERBOSE_LOG(@"adSpotInfo.htmlTemplate is empty");
            @throw [NSException exceptionWithName:@"show failed" reason:@"adSpotInfo.htmlTemplate is empty" userInfo:@{@"GAPAdSpotInfo": adSpotInfo}];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                [self applySize:adSpotInfo];
                [self applyView:adSpotInfo];
                [self applyPosition];

                self.hidden = NO;
                if (self.eventHandler) {
                    @try {
                        self.eventHandler(GAP_ADVIEW_EVENT_SUCCEEDED);
                    } @catch (NSException* exception) {
                        VERBOSE_LOG(@"exception when bannerOnSucesss callback: %@", exception);
                    }
                }
                self.state = GAP_ADVIEW_STATE_SHOWED;
            } @catch(NSException* exception) {
                GAPLog(@"failed after Ad Request: %@", exception);
                [self triggerFailure];
            }
        });
    } @catch(NSException* exception) {
        GAPLog(@"failed after Ad Request: %@", exception);
        [self triggerFailure];
    }
}

-(void) triggerFailure {
    self.state = GAP_ADVIEW_STATE_FAILED;
    dispatch_async(dispatch_get_main_queue(), ^{
        GAPLog(@"triggerFailure");
        BOOL shouldHandleFailureByDefault = YES;
        @try {
            if (self.eventHandler) {
                shouldHandleFailureByDefault = self.eventHandler(GAP_ADVIEW_EVENT_FAILED);
            }
        } @catch(NSException* exception) {
            VERBOSE_LOG(@"exception when bannerOnFailure callback: %@", exception);
        } @finally {
            if (shouldHandleFailureByDefault) {
                self.hidden = YES;
                [self removeFromSuperview];
            }
        }
    });
}

#pragma mark - implement WKNavigationDelegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    GAPLog(@"webview navigation: %@", navigationAction.request.URL);
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        GAPLog(@"clicked ad");
        NSURL* url = navigationAction.request.URL;
        if (url) {
            if (@available(iOS 10.0, *)) { // TODO too slow, may use dispatch_async
                [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success){
                    GAPLog(@"opened AD URL");
                }];
            } else {
                // Fallback on earlier versions
                [UIApplication.sharedApplication openURL:url];
            }
            GAPLog(@"WKNavigationActionPolicyCancel");
            if (self.eventHandler) {
                self.eventHandler(GAP_ADVIEW_EVENT_CLICKED);
            }
            self.state = GAP_ADVIEW_STATE_CLICKED;
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    } else {
        GAPLog(@"WKNavigationActionPolicyAllow");
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

@end
