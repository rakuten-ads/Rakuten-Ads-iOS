//
//  RPSBannerView.m
//  RPSSDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RPSBannerView.h"
#import "RPSAdWebView.h"
#import "RPSBannerAdapter.h"
#import <RPSCore/RPSValid.h>
#import "RPSDefines.h"

typedef void (^RPSBannerViewEventHandler)(RPSBannerView* view, RPSBannerViewEvent event);

typedef NS_ENUM(NSUInteger, RPSBannerViewState) {
    RPS_ADVIEW_STATE_INIT,
    RPS_ADVIEW_STATE_LOADING,
    RPS_ADVIEW_STATE_LOADED,
    RPS_ADVIEW_STATE_SHOWED,
    RPS_ADVIEW_STATE_FAILED,
    RPS_ADVIEW_STATE_CLICKED,
};

@interface RPSBannerView() <WKNavigationDelegate, RPSBidResponseConsumerDelegate>

@property (nonatomic, nonnull) RPSAdWebView* webView;
@property (nonatomic, nullable, copy) RPSBannerViewEventHandler eventHandler;
@property (nonatomic) RPSBannerViewPosition position;
@property (nonatomic, assign, nullable) UIView* parentView;
@property (atomic) RPSBannerViewState state;

@end

@implementation RPSBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        RPSDebug("trace");
        self.hidden = YES;
        self.state = RPS_ADVIEW_STATE_INIT;
    }
    return self;
}

@synthesize state = _state;

-(void)setState:(RPSBannerViewState)state {
    RPSDebug("set state %@",
           state == RPS_ADVIEW_STATE_INIT ? @"INIT" :
           state == RPS_ADVIEW_STATE_LOADING ? @"LOADING" :
           state == RPS_ADVIEW_STATE_LOADED ? @"LOADED" :
           state == RPS_ADVIEW_STATE_SHOWED ? @"SHOWED" :
           state == RPS_ADVIEW_STATE_FAILED ? @"FAILED" :
           state == RPS_ADVIEW_STATE_CLICKED ? @"CLICKED" : @"unknown");
    self->_state = state;
}

-(RPSBannerViewState)state {
    return self->_state;
}

#pragma mark - APIs
-(void)load {
    [self loadWithEventHandler:nil];
}

-(void) loadWithEventHandler:(RPSBannerViewEventHandler)handler {RPSDebug("trace");
    self.eventHandler = handler;
    dispatch_async(RPSDefines.sharedQueue, ^{
        @try {
            RPSLog("%@", RPSDefines.sharedInstance);
            if ([RPSValid isEmptyString:self.adSpotId]) {
                NSLog(@"[RPS] require adSpotId!");
                @throw [NSException exceptionWithName:@"init failed" reason:@"adSpotId is empty" userInfo:nil];
            }

            RPSBannerAdapter* bannerAdapter = [RPSBannerAdapter new];
            bannerAdapter.adspotId = self.adSpotId;
            bannerAdapter.responseConsumer = self;

            RPSOpenRTBRequest* request = [RPSOpenRTBRequest new];
            request.openRTBAdapterDelegate = bannerAdapter;

            [request resume];
            self.state = RPS_ADVIEW_STATE_LOADING;
        } @catch(NSException* exception) {
            RPSLog("load exception: %@", exception);
            [self triggerFailure];
        }
    });
}

-(void)setPosition:(RPSBannerViewPosition)position inView:(UIView *)parentView {
    if (!parentView) {
        RPSLog("parent view cannot be nil");
        return;
    }

    self.position = position;
    self.parentView = parentView;
    if (self.state == RPS_ADVIEW_STATE_SHOWED) {
        RPSDebug("re-apply position after showed");
        [self applyPosition];
    }
}

#pragma mark - UI frame control
-(void) applySize:(RPSBanner*) banner {
    float scale = UIScreen.mainScreen.scale;
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            banner.width / scale,
                            banner.height / scale);
    RPSDebug("apply size: %@", NSStringFromCGRect(self.frame));
}

-(void)applyPosition{
    if (self.parentView) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        if (![self.parentView.subviews containsObject:self]) {
            RPSDebug("add as subview");
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
        RPSDebug("apply position %@", NSStringFromCGRect(self.frame));
    }
}

-(void)applyPositionWithSafeArea API_AVAILABLE(ios(11.0)){
    RPSDebug("trace");
    UILayoutGuide* safeGuide = self.parentView.safeAreaLayoutGuide;
    switch (self.position) {
        case RPSBannerViewPositionTopLeft:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.leftAnchor constraintEqualToAnchor:safeGuide.leftAnchor],
                                                      [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                                      ]];
            break;
        case RPSBannerViewPositionTop:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.centerXAnchor constraintEqualToAnchor:safeGuide.centerXAnchor],
                                                      [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                                      ]];
            break;
        case RPSBannerViewPositionTopRight:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.rightAnchor constraintEqualToAnchor:safeGuide.rightAnchor],
                                                      [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                                      ]];
            break;
        case RPSBannerViewPositionBottomLeft:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.leftAnchor constraintEqualToAnchor:safeGuide.leftAnchor],
                                                      [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                                      ]];
            break;
        case RPSBannerViewPositionBottomRight:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.rightAnchor constraintEqualToAnchor:safeGuide.rightAnchor],
                                                      [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                                      ]];
            break;
        case RPSBannerViewPositionBottom:
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
    RPSDebug("trace");
    switch (self.position) {
        case RPSBannerViewPositionTopLeft:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.topAnchor constraintEqualToAnchor:self.parentView.topAnchor],
                                                      [self.leftAnchor constraintEqualToAnchor:self.parentView.leftAnchor],
                                                      ]];
            break;
        case RPSBannerViewPositionTop:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.topAnchor constraintEqualToAnchor:self.parentView.topAnchor],
                                                      [self.centerXAnchor constraintEqualToAnchor:self.parentView.centerXAnchor],
                                                      ]];
            break;
        case RPSBannerViewPositionTopRight:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.topAnchor constraintEqualToAnchor:self.parentView.topAnchor],
                                                      [self.rightAnchor constraintEqualToAnchor:self.parentView.rightAnchor],
                                                      ]];
            break;
        case RPSBannerViewPositionBottomLeft:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.bottomAnchor constraintEqualToAnchor:self.parentView.bottomAnchor],
                                                      [self.leftAnchor constraintEqualToAnchor:self.parentView.leftAnchor],
                                                      ]];
            break;
        case RPSBannerViewPositionBottomRight:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.bottomAnchor constraintEqualToAnchor:self.parentView.bottomAnchor],
                                                      [self.rightAnchor constraintEqualToAnchor:self.parentView.rightAnchor],
                                                      ]];
            break;
        case RPSBannerViewPositionBottom:
            [NSLayoutConstraint activateConstraints:@[
                                                      [self.bottomAnchor constraintEqualToAnchor:self.parentView.bottomAnchor],
                                                      [self.centerXAnchor constraintEqualToAnchor:self.parentView.centerXAnchor],
                                                      ]];
            break;
        default:
            ;
    }
}

-(void) applyView:(RPSBanner*) banner {
    RPSDebug("apply applyView: %@", NSStringFromCGRect(self.frame));

    // Web View
    self.webView = [[RPSAdWebView alloc]initWithFrame:self.bounds];
    self.webView.navigationDelegate = self;
    [self addSubview:self.webView];
    [self.webView loadHTMLString:banner.html baseURL:nil];
}

#pragma mark - implement RPSBidResponseConsumer
- (void)onBidResponseFailed {
    self.state = RPS_ADVIEW_STATE_LOADED;
    [self triggerFailure];
}

-(void)onBidResponseSuccess:(NSArray<RPSBanner*> *)adInfoList {
    @try {
        RPSBanner* banner = [adInfoList firstObject];
        RPSDebug("onBidResponseSuccess: %@", banner);

        self.state = RPS_ADVIEW_STATE_LOADED;

        if (!banner) {
            RPSLog("AdSpotInfo is empty");
            @throw [NSException exceptionWithName:@"load failed" reason:@"adSpotInfo is empty" userInfo:@{@"RPSAdSpotInfo": [NSNull null]}];
        }

        if ([RPSValid isEmptyString:banner.html]) {
            RPSLog("adSpotInfo.htmlTemplate is empty");
            @throw [NSException exceptionWithName:@"load failed" reason:@"adSpotInfo.htmlTemplate is empty" userInfo:@{@"RPSAdSpotInfo": banner}];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                [self applySize:banner];
                [self applyView:banner];
                [self applyPosition];

                self.hidden = NO;
                if (self.eventHandler) {
                    @try {
                        self.eventHandler(self, RPSBannerViewEventSucceeded);
                    } @catch (NSException* exception) {
                        RPSLog("exception when bannerOnSucesss callback: %@", exception);
                    }
                }
                self.state = RPS_ADVIEW_STATE_SHOWED;
            } @catch(NSException* exception) {
                RPSDebug("failed after Ad Request: %@", exception);
                [self triggerFailure];
            }
        });
    } @catch(NSException* exception) {
        RPSDebug("failed after Ad Request: %@", exception);
        [self triggerFailure];
    }
}

- (nonnull RPSBanner*)parse:(nonnull NSDictionary *)bid {
    return [RPSBanner parse:bid];
}

-(void) triggerFailure {
    self.state = RPS_ADVIEW_STATE_FAILED;
    dispatch_async(dispatch_get_main_queue(), ^{
        RPSDebug("triggerFailure");
        @try {
            if (self.eventHandler) {
                self.eventHandler(self, RPSBannerViewEventFailed);
            }
        } @catch(NSException* exception) {
            RPSLog("exception when bannerOnFailure callback: %@", exception);
        } @finally {
            self.hidden = YES;
            [self removeFromSuperview];
        }
    });
}

#pragma mark - implement WKNavigationDelegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    RPSDebug("webview navigation: %@", navigationAction.request.URL);
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        RPSDebug("clicked ad");
        NSURL* url = navigationAction.request.URL;
        if (url) {
            [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success){
                RPSDebug("opened AD URL");
            }];

            RPSDebug("WKNavigationActionPolicyCancel");
            if (self.eventHandler) {
                self.eventHandler(self, RPSBannerViewEventClicked);
            }
            self.state = RPS_ADVIEW_STATE_CLICKED;
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    } else {
        RPSDebug("WKNavigationActionPolicyAllow");
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

@end
