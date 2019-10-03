//
//  RPSBannerViewInner.m
//  RPSSDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RPSBannerViewInner.h"

@implementation RPSBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.state = RPS_ADVIEW_STATE_INIT;
        self.translatesAutoresizingMaskIntoConstraints = NO;
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

-(void) loadWithEventHandler:(RPSBannerViewEventHandler)handler {
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

-(void)setSize:(RPSBannerViewSize)size {
    self->_size = size;

    if (self.state == RPS_ADVIEW_STATE_SHOWED) {
        RPSDebug("adjust size after showed");
        [self applyContainerSize];
    }
}

-(void)setPosition:(RPSBannerViewPosition)position {
    self->_position = position;

    if (self.state == RPS_ADVIEW_STATE_SHOWED) {
        RPSDebug("re-apply position after showed");
        [self applyContainerPosition];
    }
}

#pragma mark - UI frame control
-(void) applyContainerSize {
    if (self.superview && self.banner) {
        RPSDebug("applyContainerSize %lu", self.size);

        [self.superview removeConstraints:self.sizeConstraints];
        [self removeConstraints:self.sizeConstraints];

        switch (self.size) {
            case RPSBannerViewSizeAspectFill:
                if (@available(ios 11.0, *)) {
                    UILayoutGuide* safeGuide = self.superview.safeAreaLayoutGuide;
                    self->_sizeConstraints = @[[self.widthAnchor constraintEqualToAnchor:safeGuide.widthAnchor],
                                               [self.heightAnchor constraintEqualToAnchor:safeGuide.widthAnchor multiplier:((float)self.banner.height / (float)self.banner.width)],
                                               ];
                } else {
                    self->_sizeConstraints = @[[self.widthAnchor constraintEqualToAnchor:self.superview.widthAnchor],
                                               [self.heightAnchor constraintEqualToAnchor:self.superview.widthAnchor multiplier:((float)self.banner.height / (float)self.banner.width)],
                                               ];
                }
                [self.superview addConstraints:self->_sizeConstraints];
                break;
            default:
                self->_sizeConstraints = @[[self.widthAnchor constraintEqualToConstant:self.banner.width],
                                           [self.heightAnchor constraintEqualToConstant:self.banner.height],
                                           ];
                [self addConstraints:self.sizeConstraints];
                break;
        }
    }
}

-(void)applyContainerPosition{
    if (self.superview) {
        [self.superview removeConstraints:self.positionConstraints];

        if (@available(ios 11.0, *)) {
            [self applyPositionWithSafeArea];
        } else {
            [self applyPositionWithParentView];
        }

        RPSDebug("applyContainerPosition");
        [self.superview addConstraints:self.positionConstraints];
    }
}

-(void)applyPositionWithSafeArea API_AVAILABLE(ios(11.0)){
    UILayoutGuide* safeGuide = self.superview.safeAreaLayoutGuide;
    switch (self.position) {
        case RPSBannerViewPositionTopLeft:
            self->_positionConstraints = @[[self.leftAnchor constraintEqualToAnchor:safeGuide.leftAnchor],
                                           [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                           ];
            break;
        case RPSBannerViewPositionTop:
            self->_positionConstraints = @[[self.centerXAnchor constraintEqualToAnchor:safeGuide.centerXAnchor],
                                           [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                           ];
            break;
        case RPSBannerViewPositionTopRight:
            self->_positionConstraints = @[[self.rightAnchor constraintEqualToAnchor:safeGuide.rightAnchor],
                                           [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                           ];
            break;
        case RPSBannerViewPositionBottomLeft:
            self->_positionConstraints = @[[self.leftAnchor constraintEqualToAnchor:safeGuide.leftAnchor],
                                           [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                           ];
            break;
        case RPSBannerViewPositionBottomRight:
            self->_positionConstraints = @[[self.rightAnchor constraintEqualToAnchor:safeGuide.rightAnchor],
                                           [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                           ];
            break;
        case RPSBannerViewPositionBottom:
            self->_positionConstraints = @[[self.centerXAnchor constraintEqualToAnchor:safeGuide.centerXAnchor],
                                           [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                           ];
            break;
        default:
            ;
    }
}

-(void)applyPositionWithParentView {
    switch (self.position) {
        case RPSBannerViewPositionTopLeft:
            self->_positionConstraints = @[[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor],
                                           [self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor],
                                           ];
            break;
        case RPSBannerViewPositionTop:
            self->_positionConstraints = @[[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor],
                                           [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor],
                                           ];
            break;
        case RPSBannerViewPositionTopRight:
            self->_positionConstraints = @[[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor],
                                           [self.rightAnchor constraintEqualToAnchor:self.superview.rightAnchor],
                                           ];
            break;
        case RPSBannerViewPositionBottomLeft:
            self->_positionConstraints = @[[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor],
                                           [self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor],
                                           ];
            break;
        case RPSBannerViewPositionBottomRight:
            self->_positionConstraints = @[[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor],
                                           [self.rightAnchor constraintEqualToAnchor:self.superview.rightAnchor],
                                           ];
            break;
        case RPSBannerViewPositionBottom:
            self->_positionConstraints = @[[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor],
                                           [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor],
                                           ];
            break;
        default:;
    }
}

-(void) applyAdView {
    RPSDebug("apply applyView: %@", NSStringFromCGRect(self.frame));

    // Web View
    self->_webView = [RPSAdWebView new];
    self.webView.navigationDelegate = self;
    [self addSubview:self.webView];
    [self.webView loadHTMLString:self.banner.html baseURL:nil];

    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self->_webViewConstraints = @[[self.webView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                                  [self.webView.topAnchor constraintEqualToAnchor:self.topAnchor],
                                  [self.webView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                                  [self.webView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
                                  ];
    [self addConstraints:_webViewConstraints];
}

#pragma mark - implement RPSBidResponseConsumer
- (void)onBidResponseFailed {
    self.state = RPS_ADVIEW_STATE_LOADED;
    [self triggerFailure];
}

-(void)onBidResponseSuccess:(NSArray<RPSBanner*> *)adInfoList {
    @try {
        self->_banner = [adInfoList firstObject];
        RPSDebug("onBidResponseSuccess: %@", self.banner);

        self.state = RPS_ADVIEW_STATE_LOADED;

        if (!self.banner) {
            RPSLog("AdSpotInfo is empty");
            @throw [NSException exceptionWithName:@"load failed" reason:@"banner info is empty" userInfo:@{@"RPSBanner": [NSNull null]}];
        }

        if ([RPSValid isEmptyString:self.banner.html]) {
            RPSLog("banner html is empty");
            @throw [NSException exceptionWithName:@"load failed" reason:@"banner html is empty" userInfo:@{@"RPSBanner": self.banner}];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                [self applyAdView];
                [self applyContainerSize];
                [self applyContainerPosition];
                [self layoutIfNeeded];

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
    RPSBanner* banner = [RPSBanner new];
    [banner parse:bid];
    return banner;
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
            if (self.measurement && !self.measurement.isCancelled) {
                [self.measurement cancel];
            }
            self.hidden = YES;
            self.webView.navigationDelegate = nil;
            [self removeFromSuperview];
        }
    });
}

#pragma mark - implement WKNavigationDelegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    RPSDebug("webview navigation decide for: %@", navigationAction.request.URL);
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        RPSDebug("clicked ad");
        NSURL* url = navigationAction.request.URL;
        if (url) {
            [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success){
                RPSDebug("opened AD URL");
            }];
            
            RPSDebug("WKNavigationActionPolicyCancel");
            if (self.eventHandler) {
                @try {
                    self.eventHandler(self, RPSBannerViewEventClicked);
                } @catch (NSException *exception) {
                    RPSDebug("exception on clicked event: %@", exception);
                }
            }
            self.state = RPS_ADVIEW_STATE_CLICKED;
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    } else {
        RPSDebug("WKNavigationActionPolicyAllow");
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    RPSDebug("didFinishNavigation of: %@", navigation);
    if ([self conformsToProtocol:@protocol(RPSMeasurableDelegate)]
        && self.state != RPS_ADVIEW_STATE_FAILED) {
        @try {
            self.measurement = [RPSMeasurement new];
            self.measurement.measurableTarget = (id<RPSMeasurableDelegate>)self;
            [self.measurement startMeasurement];
        } @catch (NSException *exception) {
            RPSDebug("exception when start measurement: %@", exception);
        }
    }
}

#if DEBUG
-(void)dealloc {
    RPSDebug("dealloc RPSBannerView %@", self);
}
#endif
@end
