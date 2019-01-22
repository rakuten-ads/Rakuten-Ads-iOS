//
//  RPSAdView.m
//  RPSSDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RPSAdView.h"
#import "RPSAdWebView.h"
#import "RPSAdRequest.h"
#import <RPSCore/RPSValid.h>
#import "RPSDefines.h"

typedef BOOL (^RPSAdViewEventHandler)(RPSAdViewEvent event);

typedef NS_ENUM(NSUInteger, RPSAdViewState) {
    RPS_ADVIEW_STATE_INIT,
    RPS_ADVIEW_STATE_LOADING,
    RPS_ADVIEW_STATE_LOADED,
    RPS_ADVIEW_STATE_SHOWED,
    RPS_ADVIEW_STATE_FAILED,
    RPS_ADVIEW_STATE_CLICKED,
};

@interface RPSAdView() <RPSAdRequestDelegate, WKNavigationDelegate>

@property (nonatomic, nonnull) RPSAdWebView* webView;
@property (nonatomic, nullable, copy) RPSAdViewEventHandler eventHandler;
@property (nonatomic) RPSAdViewPosition position;
@property (nonatomic, assign, nullable) UIView* parentView;
@property (atomic) RPSAdViewState state;

@end

@implementation RPSAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        RPSTrace
        self.hidden = YES;
        self.state = RPS_ADVIEW_STATE_INIT;
    }
    return self;
}

@synthesize state = _state;

-(void)setState:(RPSAdViewState)state {
    RPSLog(@"set state %@",
           state == RPS_ADVIEW_STATE_INIT ? @"INIT" :
           state == RPS_ADVIEW_STATE_LOADING ? @"LOADING" :
           state == RPS_ADVIEW_STATE_LOADED ? @"LOADED" :
           state == RPS_ADVIEW_STATE_SHOWED ? @"SHOWED" :
           state == RPS_ADVIEW_STATE_FAILED ? @"FAILED" :
           state == RPS_ADVIEW_STATE_CLICKED ? @"CLICKED" : @"unknown");
    self->_state = state;
}

-(RPSAdViewState)state {
    return self->_state;
}

#pragma mark - APIs
-(void)show {
    [self showWithEventHandler:nil];
}

-(void) showWithEventHandler:(RPSAdViewEventHandler)handler {RPSTrace
    self.eventHandler = handler;
    dispatch_async(RPSDefines.sharedQueue, ^{
        @try {
            VERBOSE_LOG(@"%@", RPSDefines.sharedInstance);
            if ([RPSValid isEmptyString:self.adSpotId]) {
                NSLog(@"[RSSP] require adSpotId!");
                @throw [NSException exceptionWithName:@"init failed" reason:@"adSpotId is empty" userInfo:nil];
            }

            RPSAdRequest* request = [[RPSAdRequest alloc]initWithAdSpotId:self.adSpotId];
            request.delegate = self;
            [request resume];
            self.state = RPS_ADVIEW_STATE_LOADING;
        } @catch(NSException* exception) {
            VERBOSE_LOG(@"show exception: %@", exception);
            [self triggerFailure];
        }
    });
}

-(void)setPosition:(RPSAdViewPosition)position inView:(UIView *)parentView {
    if (!parentView) {
        VERBOSE_LOG(@"parent view cannot be nil");
        return;
    }

    self.position = position;
    self.parentView = parentView;
    if (self.state == RPS_ADVIEW_STATE_SHOWED) {
        RPSLog(@"re-apply position after showed");
        [self applyPosition];
    }
}

#pragma mark - UI frame control
-(void) applySize:(RPSAdSpotInfo*) adSpotInfo {
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            adSpotInfo.width,
                            adSpotInfo.height);
    RPSLog(@"apply size: %@", NSStringFromCGRect(self.frame));
}

-(void)applyPosition{
    if (self.parentView) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        if (![self.parentView.subviews containsObject:self]) {
            RPSLog(@"add as subview");
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
        RPSLog(@"apply position %@", NSStringFromCGRect(self.frame));
    }
}

-(void)applyPositionWithSafeArea API_AVAILABLE(ios(11.0)){
    RPSTrace
    UILayoutGuide* safeGuide = self.parentView.safeAreaLayoutGuide;
    switch (self.position) {
        case RPS_ADVIEW_POSITION_TOP_LEFT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.leftAnchor constraintEqualToAnchor:safeGuide.leftAnchor],
                                                      [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                                      ]];
            break;
        case RPS_ADVIEW_POSITION_TOP:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.centerXAnchor constraintEqualToAnchor:safeGuide.centerXAnchor],
                                                      [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                                      ]];
            break;
        case RPS_ADVIEW_POSITION_TOP_RIGHT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.rightAnchor constraintEqualToAnchor:safeGuide.rightAnchor],
                                                      [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                                      ]];
            break;
        case RPS_ADVIEW_POSITION_BOTTOM_LEFT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.leftAnchor constraintEqualToAnchor:safeGuide.leftAnchor],
                                                      [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                                      ]];
            break;
        case RPS_ADVIEW_POSITION_BOTTOM_RIGHT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.rightAnchor constraintEqualToAnchor:safeGuide.rightAnchor],
                                                      [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                                      ]];
            break;
        case RPS_ADVIEW_POSITION_BOTTOM:
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
    RPSTrace
    switch (self.position) {
        case RPS_ADVIEW_POSITION_TOP_LEFT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.topAnchor constraintEqualToAnchor:self.parentView.topAnchor],
                                                      [self.leftAnchor constraintEqualToAnchor:self.parentView.leftAnchor],
                                                      ]];
            break;
        case RPS_ADVIEW_POSITION_TOP:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.topAnchor constraintEqualToAnchor:self.parentView.topAnchor],
                                                      [self.centerXAnchor constraintEqualToAnchor:self.parentView.centerXAnchor],
                                                      ]];
            break;
        case RPS_ADVIEW_POSITION_TOP_RIGHT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.topAnchor constraintEqualToAnchor:self.parentView.topAnchor],
                                                      [self.rightAnchor constraintEqualToAnchor:self.parentView.rightAnchor],
                                                      ]];
            break;
        case RPS_ADVIEW_POSITION_BOTTOM_LEFT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.bottomAnchor constraintEqualToAnchor:self.parentView.bottomAnchor],
                                                      [self.leftAnchor constraintEqualToAnchor:self.parentView.leftAnchor],
                                                      ]];
            break;
        case RPS_ADVIEW_POSITION_BOTTOM_RIGHT:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.bottomAnchor constraintEqualToAnchor:self.parentView.bottomAnchor],
                                                      [self.rightAnchor constraintEqualToAnchor:self.parentView.rightAnchor],
                                                      ]];
            break;
        case RPS_ADVIEW_POSITION_BOTTOM:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.bottomAnchor constraintEqualToAnchor:self.parentView.bottomAnchor],
                                                      [self.centerXAnchor constraintEqualToAnchor:self.parentView.centerXAnchor],
                                                      ]];
            break;
        default:
            ;
    }
}

-(void) applyView:(RPSAdSpotInfo*) adSpotInfo {
    RPSLog(@"apply applyView: %@", NSStringFromCGRect(self.frame));

    // Web View
    self.webView = [[RPSAdWebView alloc]initWithFrame:self.bounds];
    self.webView.navigationDelegate = self;
    [self addSubview:self.webView];
    [self.webView loadHTMLString:adSpotInfo.html baseURL:nil];
}

#pragma mark - implement RPSAdRequestDelegate

-(void)adRequestOnFailure {
    self.state = RPS_ADVIEW_STATE_LOADED;
    [self triggerFailure];
}

-(void)adRequestOnSuccess:(RPSAdSpotInfo *)adSpotInfo {
    @try {
        RPSLog(@"adRequestOnSuccess: %@", adSpotInfo);
        self.state = RPS_ADVIEW_STATE_LOADED;

        if (!adSpotInfo) {
            VERBOSE_LOG(@"AdSpotInfo is empty");
            @throw [NSException exceptionWithName:@"show failed" reason:@"adSpotInfo is empty" userInfo:@{@"RPSAdSpotInfo": [NSNull null]}];
        }

        if ([RPSValid isEmptyString:adSpotInfo.html]) {
            VERBOSE_LOG(@"adSpotInfo.htmlTemplate is empty");
            @throw [NSException exceptionWithName:@"show failed" reason:@"adSpotInfo.htmlTemplate is empty" userInfo:@{@"RPSAdSpotInfo": adSpotInfo}];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                [self applySize:adSpotInfo];
                [self applyView:adSpotInfo];
                [self applyPosition];

                self.hidden = NO;
                if (self.eventHandler) {
                    @try {
                        self.eventHandler(RPS_ADVIEW_EVENT_SUCCEEDED);
                    } @catch (NSException* exception) {
                        VERBOSE_LOG(@"exception when bannerOnSucesss callback: %@", exception);
                    }
                }
                self.state = RPS_ADVIEW_STATE_SHOWED;
            } @catch(NSException* exception) {
                RPSLog(@"failed after Ad Request: %@", exception);
                [self triggerFailure];
            }
        });
    } @catch(NSException* exception) {
        RPSLog(@"failed after Ad Request: %@", exception);
        [self triggerFailure];
    }
}

-(void) triggerFailure {
    self.state = RPS_ADVIEW_STATE_FAILED;
    dispatch_async(dispatch_get_main_queue(), ^{
        RPSLog(@"triggerFailure");
        BOOL shouldHandleFailureByDefault = YES;
        @try {
            if (self.eventHandler) {
                shouldHandleFailureByDefault = self.eventHandler(RPS_ADVIEW_EVENT_FAILED);
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
    RPSLog(@"webview navigation: %@", navigationAction.request.URL);
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        RPSLog(@"clicked ad");
        NSURL* url = navigationAction.request.URL;
        if (url) {
            if (@available(iOS 10.0, *)) { // TODO too slow, may use dispatch_async
                [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success){
                    RPSLog(@"opened AD URL");
                }];
            } else {
                // Fallback on earlier versions
                [UIApplication.sharedApplication openURL:url];
            }
            RPSLog(@"WKNavigationActionPolicyCancel");
            if (self.eventHandler) {
                self.eventHandler(RPS_ADVIEW_EVENT_CLICKED);
            }
            self.state = RPS_ADVIEW_STATE_CLICKED;
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    } else {
        RPSLog(@"WKNavigationActionPolicyAllow");
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

@end
