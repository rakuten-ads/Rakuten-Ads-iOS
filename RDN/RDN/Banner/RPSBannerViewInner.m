//
//  RPSBannerViewInner.m
//  RPSSDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RPSBannerViewInner.h"
#import "RPSBannerModel.h"

typedef void (^RPSBannerViewEventHandler)(RPSBannerView* view, RPSBannerViewEvent event);

typedef NS_ENUM(NSUInteger, RPSBannerViewState) {
    RPS_ADVIEW_STATE_INIT,
    RPS_ADVIEW_STATE_LOADING,
    RPS_ADVIEW_STATE_LOADED,
    RPS_ADVIEW_STATE_FAILED,
    RPS_ADVIEW_STATE_RENDERING,
    RPS_ADVIEW_STATE_MESSAGE_LISTENING,
    RPS_ADVIEW_STATE_SHOWED,
    RPS_ADVIEW_STATE_CLICKED,
};

@interface RPSBannerView() <WKNavigationDelegate, RPSBidResponseConsumerDelegate, WKScriptMessageHandler>

@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* sizeConstraints;
@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* positionConstraints;
@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* webViewConstraints;
@property (nonatomic, readonly, nullable) RPSAdWebView* webView;
@property (nonatomic, nullable, copy) RPSBannerViewEventHandler eventHandler;
@property (atomic, readonly) RPSBannerViewState state;
@property (nonatomic, nullable) RPSMeasurement* measurement;

@end



@implementation RPSBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
             state == RPS_ADVIEW_STATE_RENDERING ? @"RENDERING":
             state == RPS_ADVIEW_STATE_MESSAGE_LISTENING ? @"MESSAGE_LISTENING":
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
            bannerAdapter.json = self.jsonProperties;
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

-(void)setProperties:(NSDictionary *)properties {
    self.jsonProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
}

-(NSDictionary *)properties {
    return self.jsonProperties;
}

#pragma mark - UI frame control
-(void)didMoveToSuperview {
    RPSDebug("didMoveToSuperview");
    [self applyContainerSize];
    [self applyContainerPosition];
    [self layoutIfNeeded];
}

-(void) applyContainerSize {
    if (self.superview && self.banner) {
        RPSDebug("applyContainerSize %lu", self.size);

        [self.superview removeConstraints:self.sizeConstraints];
        [self removeConstraints:self.sizeConstraints];

        switch (self.size) {
            case RPSBannerViewSizeAspectFit:
                if (@available(ios 11.0, *)) {
                    UILayoutGuide* safeGuide = self.superview.safeAreaLayoutGuide;
                    self->_sizeConstraints = @[[self.widthAnchor constraintEqualToAnchor:safeGuide.widthAnchor],
                                               [self.heightAnchor constraintEqualToAnchor:safeGuide.widthAnchor multiplier:self.banner.height / self.banner.width],
                                               ];
                } else {
                    self->_sizeConstraints = @[[self.widthAnchor constraintEqualToAnchor:self.superview.widthAnchor],
                                               [self.heightAnchor constraintEqualToAnchor:self.superview.widthAnchor multiplier:self.banner.height / self.banner.width],
                                               ];
                }
                self.translatesAutoresizingMaskIntoConstraints = NO;
                [self.superview addConstraints:self.sizeConstraints];
                break;

            case RPSBannerViewSizeDefault:
                self->_sizeConstraints = @[[self.widthAnchor constraintEqualToConstant:self.banner.width],
                                           [self.heightAnchor constraintEqualToConstant:self.banner.height],
                                           ];
                self.translatesAutoresizingMaskIntoConstraints = NO;
                [self addConstraints:self.sizeConstraints];
                break;

            case RPSBannerViewSizeCustom: default:
                self->_sizeConstraints = nil;
        }
    }
}

-(void)applyContainerPosition{
    if (self.superview) {
        RPSDebug("applyContainerPosition %lu", self.position);
        [self.superview removeConstraints:self.positionConstraints];

        if (@available(ios 11.0, *)) {
            [self applyPositionWithSafeArea];
        } else {
            [self applyPositionWithParentView];
        }

        if (self.position != RPSBannerViewPositionCustom) {
            self.translatesAutoresizingMaskIntoConstraints = NO;
            [self.superview addConstraints:self.positionConstraints];
        }
    }
}

-(void)applyPositionWithSafeArea API_AVAILABLE(ios(11.0)){
    UILayoutGuide* safeGuide = self.superview.safeAreaLayoutGuide;
    switch (self.position) {
        case RPSBannerViewPositionTopLeft:
            self->_positionConstraints = @[[self.leadingAnchor constraintEqualToAnchor:safeGuide.leadingAnchor],
                                           [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                           ];
            break;
        case RPSBannerViewPositionTop:
            self->_positionConstraints = @[[self.centerXAnchor constraintEqualToAnchor:safeGuide.centerXAnchor],
                                           [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                           ];
            break;
        case RPSBannerViewPositionTopRight:
            self->_positionConstraints = @[[self.trailingAnchor constraintEqualToAnchor:safeGuide.trailingAnchor],
                                           [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                           ];
            break;
        case RPSBannerViewPositionBottomLeft:
            self->_positionConstraints = @[[self.leadingAnchor constraintEqualToAnchor:safeGuide.leadingAnchor],
                                           [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                           ];
            break;
        case RPSBannerViewPositionBottomRight:
            self->_positionConstraints = @[[self.trailingAnchor constraintEqualToAnchor:safeGuide.trailingAnchor],
                                           [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                           ];
            break;
        case RPSBannerViewPositionBottom:
            self->_positionConstraints = @[[self.centerXAnchor constraintEqualToAnchor:safeGuide.centerXAnchor],
                                           [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                           ];
            break;
        case RPSBannerViewPositionCustom: default:
            self->_positionConstraints = nil;
    }
}

-(void)applyPositionWithParentView {
    switch (self.position) {
        case RPSBannerViewPositionTopLeft:
            self->_positionConstraints = @[[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor],
                                           [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor],
                                           ];
            break;
        case RPSBannerViewPositionTop:
            self->_positionConstraints = @[[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor],
                                           [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor],
                                           ];
            break;
        case RPSBannerViewPositionTopRight:
            self->_positionConstraints = @[[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor],
                                           [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor],
                                           ];
            break;
        case RPSBannerViewPositionBottomLeft:
            self->_positionConstraints = @[[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor],
                                           [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor],
                                           ];
            break;
        case RPSBannerViewPositionBottomRight:
            self->_positionConstraints = @[[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor],
                                           [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor],
                                           ];
            break;
        case RPSBannerViewPositionBottom:
            self->_positionConstraints = @[[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor],
                                           [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor],
                                           ];
            break;
        case RPSBannerViewPositionCustom: default:
            self->_positionConstraints = nil;
    }
}

-(void) applyAdView {
    RPSDebug("apply applyView: %@", NSStringFromCGRect(self.frame));

    // Web View
    self->_webView = [RPSAdWebView new];
    [self->_webView.configuration.userContentController addScriptMessageHandler:self name:kSdkMessageHandler];

    self.webView.navigationDelegate = self;
    [self addSubview:self.webView];
    [self.webView loadHTMLString:self.banner.html baseURL:[NSURL URLWithString:@"https://rakuten.co.jp"]];
    
    self.state = RPS_ADVIEW_STATE_RENDERING;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self->_webViewConstraints = @[[self.webView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                                  [self.webView.topAnchor constraintEqualToAnchor:self.topAnchor],
                                  [self.webView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                                  [self.webView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
                                  ];
    [self addConstraints:self.webViewConstraints];
}

#pragma mark - implement RPSBidResponseConsumer
- (void)onBidResponseFailed {
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
            } @catch(NSException* exception) {
                RPSDebug("failed to apply Ad request: %@", exception);
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

-(void) triggerSuccess {
    if (self.state == RPS_ADVIEW_STATE_SHOWED || self.state == RPS_ADVIEW_STATE_FAILED) {
        return;
    }

    self.state = RPS_ADVIEW_STATE_SHOWED;
    dispatch_async(dispatch_get_main_queue(), ^{
        RPSDebug("triggerSuccess");
        self.hidden = NO;
        if (self.eventHandler) {
            @try {
                self.eventHandler(self, RPSBannerViewEventSucceeded);
            } @catch (NSException* exception) {
                RPSLog("exception when bannerOnSucesss callback: %@", exception);
            }
        }
    });
}

-(void) triggerFailure {
    if (self.state == RPS_ADVIEW_STATE_FAILED || self.state == RPS_ADVIEW_STATE_SHOWED) {
        return;
    }

    self.state = RPS_ADVIEW_STATE_FAILED;
    dispatch_async(dispatch_get_main_queue(), ^{
        RPSDebug("triggerFailure");
        self.hidden = YES;
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
    if (self.state != RPS_ADVIEW_STATE_FAILED) {
        if ([self conformsToProtocol:@protocol(RPSMeasurableDelegate)]) {
            @try {
                self.measurement = [RPSMeasurement new];
                self.measurement.measurableTarget = (id<RPSMeasurableDelegate>)self;
                [self.measurement startMeasurement];
            } @catch (NSException *exception) {
                RPSDebug("exception when start measurement: %@", exception);
            }
        }
    }
}


#pragma mark - implement WKScriptMessageHandler
NSString *kSdkMessageHandler = @"rpsSdkInterface";
NSString *kSdkMessageTypeExpand = @"expand";
NSString *kSdkMessageTypeCollapse = @"collapse";
NSString *kSdkMessageTypeRegister = @"register";
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    RPSDebug("received posted message %@", [message debugDescription]);
    if ([message.name isEqualToString:kSdkMessageHandler]
        && message.body) {
        @try {
            if ([message.body isKindOfClass:[NSDictionary class]]) {
                RPSAdWebViewMessage* sdkMessage = [RPSAdWebViewMessage parse:(NSDictionary*)message.body];
                RPSDebug("sdk message %@", sdkMessage);
                if ([sdkMessage.type isEqualToString:kSdkMessageTypeRegister]) {
                    self.state = RPS_ADVIEW_STATE_MESSAGE_LISTENING;
                } else if ([sdkMessage.type isEqualToString:kSdkMessageTypeExpand]) {
                    [self triggerSuccess];
                } else if ([sdkMessage.type isEqualToString:kSdkMessageTypeCollapse]) {
                    [self triggerFailure];
                }
            } else {
                RPSDebug("%@", message.body);
            }
        } @catch (NSException *exception) {
            RPSDebug("exception when waiting post message: %@", exception);
            [self triggerFailure];
        }
    }
}

#if DEBUG
-(void)dealloc {
    RPSDebug("dealloc RPSBannerView %@", self);
}
#endif
@end
