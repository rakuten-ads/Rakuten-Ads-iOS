//
//  RUNABannerViewInner.m
//  RUNASDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RUNABannerViewInner.h"

typedef void (^RUNABannerViewEventHandler)(RUNABannerView* view, struct RUNABannerViewEvent event);

typedef NS_ENUM(NSUInteger, RUNABannerViewState) {
    RUNA_ADVIEW_STATE_INIT,
    RUNA_ADVIEW_STATE_LOADING,
    RUNA_ADVIEW_STATE_LOADED,
    RUNA_ADVIEW_STATE_FAILED,
    RUNA_ADVIEW_STATE_RENDERING,
    RUNA_ADVIEW_STATE_MESSAGE_LISTENING,
    RUNA_ADVIEW_STATE_SHOWED,
    RUNA_ADVIEW_STATE_CLICKED,
};

#if RUNA_PRODUCTION
    NSString* BASE_URL_RUNA_JS = @"https://s-dlv.rmp.rakuten.co.jp";
#elif RUNA_STAGING
    NSString* BASE_URL_RUNA_JS = @"https://stg-s-dlv.rmp.rakuten.co.jp";
#else
    NSString* BASE_URL_RUNA_JS = @"https://dev-s-dlv.rmp.rakuten.co.jp";
#endif

@interface RUNABannerView() <WKNavigationDelegate, RUNABidResponseConsumerDelegate>

@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* sizeConstraints;
@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* positionConstraints;
@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* webViewConstraints;
@property (nonatomic, nullable, copy) RUNABannerViewEventHandler eventHandler;
@property (atomic, readonly) RUNABannerViewState state;

@end



@implementation RUNABannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setInitState];
        self.jsonProperties = [NSMutableDictionary dictionary];
        self.measurers = [NSMutableArray array];
    }
    return self;
}

-(void) setInitState {
    self.hidden = YES;
    self.state = RUNA_ADVIEW_STATE_INIT;
    self.error = RUNABannerViewErrorNone;
}

@synthesize state = _state;

-(void)setState:(RUNABannerViewState)state {
    RUNADebug("set state %@",
             state == RUNA_ADVIEW_STATE_INIT ? @"INIT" :
             state == RUNA_ADVIEW_STATE_LOADING ? @"LOADING" :
             state == RUNA_ADVIEW_STATE_LOADED ? @"LOADED" :
             state == RUNA_ADVIEW_STATE_FAILED ? @"FAILED" :
             state == RUNA_ADVIEW_STATE_RENDERING ? @"RENDERING":
             state == RUNA_ADVIEW_STATE_MESSAGE_LISTENING ? @"MESSAGE_LISTENING":
             state == RUNA_ADVIEW_STATE_SHOWED ? @"SHOWED" :
             state == RUNA_ADVIEW_STATE_CLICKED ? @"CLICKED" : @"unknown");
    self->_state = state;
}

-(RUNABannerViewState)state {
    return self->_state;
}

#pragma mark - APIs
-(void)load {
    [self loadWithEventHandler:nil];
}

-(void) loadWithEventHandler:(RUNABannerViewEventHandler)handler {
    [self setInitState];
    self.eventHandler = handler;
    dispatch_async(RUNADefines.sharedQueue, ^{
        @try {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                RUNALog("SDK RUNA/Banner Version: %@",
                      [[[NSBundle bundleForClass:self.class] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
                      );
                RUNALog("%@", RUNADefines.sharedInstance);
            });
            
            if ([RUNAValid isEmptyString:self.adSpotId]) {
                NSLog(@"[RUNA] require adSpotId!");
                self.error = RUNABannerViewErrorFatal;
                @throw [NSException exceptionWithName:@"init failed" reason:@"adSpotId is empty" userInfo:nil];
            }

            RUNABannerAdapter* bannerAdapter = [RUNABannerAdapter new];
            bannerAdapter.adspotId = self.adSpotId;
            if ([self conformsToProtocol:@protocol(RUNAOpenMeasurement)]
                && !self.openMeasurementDisabled) {
                bannerAdapter.banner = @{ @"api": @[@(7)] };
            }
            bannerAdapter.json = self.jsonProperties;
            bannerAdapter.appContent = self.appContent;
            bannerAdapter.responseConsumer = self;
            
            RUNAOpenRTBRequest* request = [RUNAOpenRTBRequest new];
            request.openRTBAdapterDelegate = bannerAdapter;

            [request resume];
            self.state = RUNA_ADVIEW_STATE_LOADING;
        } @catch(NSException* exception) {
            RUNALog("load exception: %@", exception);
            if (self.error == RUNABannerViewErrorNone) {
                self.error = RUNABannerViewErrorInternal;
            }
            [self triggerFailure];
        }
    });
}

-(void)setSize:(RUNABannerViewSize)size {
    self->_size = size;

    if (self.state == RUNA_ADVIEW_STATE_SHOWED) {
        RUNADebug("adjust size after showed");
        [self applyContainerSize];
    }
}

-(void)setPosition:(RUNABannerViewPosition)position {
    self->_position = position;

    if (self.state == RUNA_ADVIEW_STATE_SHOWED) {
        RUNADebug("re-apply position after showed");
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
    RUNADebug("didMoveToSuperview");
    [self applyContainerSize];
    [self applyContainerPosition];
    [self layoutIfNeeded];
}

-(void)removeFromSuperview {
    [super removeFromSuperview];
    [self.measurers enumerateObjectsUsingBlock:^(id<RUNAMeasurer>  _Nonnull measurer, NSUInteger idx, BOOL * _Nonnull stop) {
        [measurer finishMeasurement];
    }];
}

-(void) applyContainerSize {
    if (self.superview && self.banner) {
        RUNADebug("applyContainerSize %lu", (unsigned long)self.size);

        [self.superview removeConstraints:self.sizeConstraints];
        [self removeConstraints:self.sizeConstraints];

        switch (self.size) {
            case RUNABannerViewSizeAspectFit:
                if (@available(ios 11.0, *)) {
                    UILayoutGuide* safeGuide = self.superview.safeAreaLayoutGuide;
                    self->_sizeConstraints = @[[self.widthAnchor constraintEqualToAnchor:safeGuide.widthAnchor],
                                               [self.heightAnchor constraintEqualToAnchor:safeGuide.widthAnchor multiplier:(self.banner.height / self.banner.width) constant:0.5],
                                               ];
                } else {
                    self->_sizeConstraints = @[[self.widthAnchor constraintEqualToAnchor:self.superview.widthAnchor],
                                               [self.heightAnchor constraintEqualToAnchor:self.superview.widthAnchor multiplier:(self.banner.height / self.banner.width) constant:0.5],
                                               ];
                }
                self.translatesAutoresizingMaskIntoConstraints = NO;
                [self.superview addConstraints:self.sizeConstraints];
                break;

            case RUNABannerViewSizeDefault:
                self->_sizeConstraints = @[[self.widthAnchor constraintEqualToConstant:self.banner.width],
                                           [self.heightAnchor constraintEqualToConstant:self.banner.height],
                                           ];
                self.translatesAutoresizingMaskIntoConstraints = NO;
                [self addConstraints:self.sizeConstraints];
                break;

            case RUNABannerViewSizeCustom: default:
                self->_sizeConstraints = nil;
        }
    }
}

-(void)applyContainerPosition{
    if (self.superview) {
        RUNADebug("applyContainerPosition %lu", (unsigned long)self.position);
        [self.superview removeConstraints:self.positionConstraints];

        if (@available(ios 11.0, *)) {
            [self applyPositionWithSafeArea];
        } else {
            [self applyPositionWithParentView];
        }

        if (self.position != RUNABannerViewPositionCustom) {
            self.translatesAutoresizingMaskIntoConstraints = NO;
            [self.superview addConstraints:self.positionConstraints];
        }
    }
}

-(void)applyPositionWithSafeArea API_AVAILABLE(ios(11.0)){
    UILayoutGuide* safeGuide = self.superview.safeAreaLayoutGuide;
    switch (self.position) {
        case RUNABannerViewPositionTopLeft:
            self->_positionConstraints = @[[self.leadingAnchor constraintEqualToAnchor:safeGuide.leadingAnchor],
                                           [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                           ];
            break;
        case RUNABannerViewPositionTop:
            self->_positionConstraints = @[[self.centerXAnchor constraintEqualToAnchor:safeGuide.centerXAnchor],
                                           [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                           ];
            break;
        case RUNABannerViewPositionTopRight:
            self->_positionConstraints = @[[self.trailingAnchor constraintEqualToAnchor:safeGuide.trailingAnchor],
                                           [self.topAnchor constraintEqualToAnchor:safeGuide.topAnchor],
                                           ];
            break;
        case RUNABannerViewPositionBottomLeft:
            self->_positionConstraints = @[[self.leadingAnchor constraintEqualToAnchor:safeGuide.leadingAnchor],
                                           [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                           ];
            break;
        case RUNABannerViewPositionBottomRight:
            self->_positionConstraints = @[[self.trailingAnchor constraintEqualToAnchor:safeGuide.trailingAnchor],
                                           [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                           ];
            break;
        case RUNABannerViewPositionBottom:
            self->_positionConstraints = @[[self.centerXAnchor constraintEqualToAnchor:safeGuide.centerXAnchor],
                                           [self.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor],
                                           ];
            break;
        case RUNABannerViewPositionCustom: default:
            self->_positionConstraints = nil;
    }
}

-(void)applyPositionWithParentView {
    switch (self.position) {
        case RUNABannerViewPositionTopLeft:
            self->_positionConstraints = @[[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor],
                                           [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor],
                                           ];
            break;
        case RUNABannerViewPositionTop:
            self->_positionConstraints = @[[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor],
                                           [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor],
                                           ];
            break;
        case RUNABannerViewPositionTopRight:
            self->_positionConstraints = @[[self.topAnchor constraintEqualToAnchor:self.superview.topAnchor],
                                           [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor],
                                           ];
            break;
        case RUNABannerViewPositionBottomLeft:
            self->_positionConstraints = @[[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor],
                                           [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor],
                                           ];
            break;
        case RUNABannerViewPositionBottomRight:
            self->_positionConstraints = @[[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor],
                                           [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor],
                                           ];
            break;
        case RUNABannerViewPositionBottom:
            self->_positionConstraints = @[[self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor],
                                           [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor],
                                           ];
            break;
        case RUNABannerViewPositionCustom: default:
            self->_positionConstraints = nil;
    }
}

-(void) applyAdView {
    RUNADebug("apply applyView: %@", NSStringFromCGRect(self.frame));
    // remove old web view
    if (self.webView
        && self.webView.superview == self) {
        [self.webView removeFromSuperview];
    }
    
    // Web View
    self->_webView = [RUNAAdWebView new];
    [self->_webView addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeExpand handle:^(RUNAAdWebViewMessage * _Nonnull message) {
        RUNADebug("handle %@", message.type);
        [self triggerSuccess];
    }]];
    [self->_webView addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeCollapse handle:^(RUNAAdWebViewMessage * _Nonnull message) {
        RUNADebug("handle %@", message.type);
        [self triggerFailure];
    }]];
    [self->_webView addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeRegister handle:^(RUNAAdWebViewMessage * _Nonnull message) {
        RUNADebug("handle %@", message.type);
        self.state = RUNA_ADVIEW_STATE_MESSAGE_LISTENING;
    }]];
    [self->_webView addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeUnfilled handle:^(RUNAAdWebViewMessage * _Nonnull message) {
        RUNADebug("handle %@", message.type);
        self.error = RUNABannerViewErrorUnfilled;
        [self triggerFailure];
    }]];

    // message type open_popup, for like a2a
    if (self.openPopupHandler) {
        [self->_webView addMessageHandler:self.openPopupHandler];
    }

    self.webView.navigationDelegate = self;
    [self addSubview:self.webView];
    
    NSString* html = self.banner.html;
    if ([self isOpenMeasurementAvailable]) {
        html = [(id<RUNAOpenMeasurement>)self injectOMProvider:self.banner.viewabilityProviderURL IntoHTML:html];
    }
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:BASE_URL_RUNA_JS]];
    
    self.state = RUNA_ADVIEW_STATE_RENDERING;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self->_webViewConstraints = @[[self.webView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                                  [self.webView.topAnchor constraintEqualToAnchor:self.topAnchor],
                                  [self.webView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                                  [self.webView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
                                  ];
    [self addConstraints:self.webViewConstraints];
}

- (BOOL)isOpenMeasurementAvailable {
    return [self conformsToProtocol:@protocol(RUNAOpenMeasurement)]
    && !self.openMeasurementDisabled
    && self.banner.viewabilityProviderURL;
}

#pragma mark - implement RUNABidResponseConsumer
- (void)onBidResponseFailed:(NSHTTPURLResponse *)response error:(NSError *)error {
    if (response.statusCode == kRUNABidResponseUnfilled) {
        self.error = RUNABannerViewErrorUnfilled;
    } else if (error) {
        self.error = RUNABannerViewErrorNetwork;
    }
    [self triggerFailure];
}

-(void)onBidResponseSuccess:(NSArray<RUNABanner*> *)adInfoList {
    @try {
        self->_banner = [adInfoList firstObject];
        RUNADebug("onBidResponseSuccess: %@", self.banner);

        self.state = RUNA_ADVIEW_STATE_LOADED;

        if (!self.banner) {
            RUNALog("AdSpotInfo is empty");
            self.error = RUNABannerViewErrorInternal;
            @throw [NSException exceptionWithName:@"load failed" reason:@"banner info is empty" userInfo:@{@"RUNABanner": [NSNull null]}];
        }

        if ([RUNAValid isEmptyString:self.banner.html]) {
            RUNALog("banner html is empty");
            self.error = RUNABannerViewErrorInternal;
            @throw [NSException exceptionWithName:@"load failed" reason:@"banner html is empty" userInfo:@{@"RUNABanner": self.banner}];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                [self applyAdView];
                [self applyContainerSize];
                [self applyContainerPosition];
                [self layoutIfNeeded];
            } @catch(NSException* exception) {
                RUNADebug("failed to apply Ad request: %@", exception);
                if (self.error == RUNABannerViewErrorNone) {
                    self.error = RUNABannerViewErrorInternal;
                }
                [self triggerFailure];
            }
        });
    } @catch(NSException* exception) {
        RUNADebug("failed after Ad Request: %@", exception);
        if (self.error == RUNABannerViewErrorNone) {
            self.error = RUNABannerViewErrorInternal;
        }
        [self triggerFailure];
    }
}

- (nonnull RUNABanner*)parse:(nonnull NSDictionary *)bid {
    RUNABanner* banner = [RUNABanner new];
    [banner parse:bid];
    return banner;
}

-(void) triggerSuccess {
    if (self.state == RUNA_ADVIEW_STATE_SHOWED || self.state == RUNA_ADVIEW_STATE_FAILED) {
        return;
    }

    self.state = RUNA_ADVIEW_STATE_SHOWED;
    dispatch_async(dispatch_get_main_queue(), ^{
        RUNADebug("triggerSuccess");
        self.hidden = NO;
        if (self.eventHandler) {
            @try {
                struct RUNABannerViewEvent event = { RUNABannerViewEventTypeSucceeded, self.error };
                self.eventHandler(self, event);
            } @catch (NSException* exception) {
                RUNALog("exception when bannerOnSucesss callback: %@", exception);
            }
        }
    });
}

-(void) triggerFailure {
    if (self.state == RUNA_ADVIEW_STATE_FAILED || self.state == RUNA_ADVIEW_STATE_SHOWED) {
        return;
    }

    self.state = RUNA_ADVIEW_STATE_FAILED;
    dispatch_async(dispatch_get_main_queue(), ^{
        RUNADebug("triggerFailure");
        self.hidden = YES;
        @try {
            if (self.eventHandler) {
                struct RUNABannerViewEvent event = { RUNABannerViewEventTypeFailed, self.error };
                self.eventHandler(self, event);
            }
        } @catch(NSException* exception) {
            RUNALog("exception when bannerOnFailure callback: %@", exception);
        } @finally {
            [self.measurers enumerateObjectsUsingBlock:^(id<RUNAMeasurer>  _Nonnull measurer, NSUInteger idx, BOOL * _Nonnull stop) {
                [measurer finishMeasurement];
            }];
            self.hidden = YES;
            self.webView.navigationDelegate = nil;
            [self.webView removeFromSuperview];
        }
    });
}

#pragma mark - implement WKNavigationDelegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    RUNADebug("webview navigation type %lu decide for: %@", (unsigned long)navigationAction.navigationType, navigationAction.request.URL);
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        RUNADebug("clicked ad");
        NSURL* url = navigationAction.request.URL;
        if (url) {
            [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success){
                RUNADebug("opened AD URL");
            }];
            
            RUNADebug("WKNavigationActionPolicyCancel");
            if (self.eventHandler) {
                @try {
                    struct RUNABannerViewEvent event = { RUNABannerViewEventTypeClicked, self.error };
                    self.eventHandler(self, event);
                } @catch (NSException *exception) {
                    RUNADebug("exception on clicked event: %@", exception);
                }
            }
            self.state = RUNA_ADVIEW_STATE_CLICKED;
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }

    RUNADebug("WKNavigationActionPolicyAllow");
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    RUNADebug("didStartProvisionalNavigation");
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    RUNADebug("didFinishNavigation");
    if (self.state != RUNA_ADVIEW_STATE_FAILED) {
        @try {
            if ([self isOpenMeasurementAvailable]) {
                [self.measurers addObject:[(id<RUNAOpenMeasurement>)self getOpenMeasurer]];
            }
            if ([self conformsToProtocol:@protocol(RUNADefaultMeasurement)]) {
                [self.measurers addObject:[(id<RUNADefaultMeasurement>)self getDefaultMeasurer]];
            }
            [self.measurers enumerateObjectsUsingBlock:^(id<RUNAMeasurer>  _Nonnull measurer, NSUInteger idx, BOOL * _Nonnull stop) {
                [measurer startMeasurement];
            }];
        } @catch (NSException *exception) {
            RUNADebug("exception when start measurement: %@", exception);
        }
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    RUNALog("AD view didFailNavigation %@", error);
}

-(NSString *)description {
    return [NSString stringWithFormat:
            @"{\n"
            @"adspotId: %@\n"
            @"properties: %@\n"
            @"content: %@\n"
            @"}",
            self.adSpotId,
            self.properties,
            self.appContent,
            nil];
}

#if DEBUG
-(void)dealloc {
    RUNADebug("dealloc RUNABannerView %@", self);
}
#endif
@end
