//
//  RUNABannerViewInner.m
//  RUNASDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RUNABannerViewInner.h"

#if RUNA_PRODUCTION
    NSString* BASE_URL_RUNA_JS = @"https://s-dlv.rmp.rakuten.co.jp";
#elif RUNA_STAGING
    NSString* BASE_URL_RUNA_JS = @"https://stg-s-dlv.rmp.rakuten.co.jp";
#else
    NSString* BASE_URL_RUNA_JS = @"https://dev-s-dlv.rmp.rakuten.co.jp";
#endif

NSString* BASE_URL_BLANK = @"about:blank";
NSString* kSdkMessageHandlerName = @"runaSdkInterface";

@interface RUNABannerView() <WKNavigationDelegate, RUNAMeasurerDelegate>

@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* sizeConstraints;
@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* positionConstraints;
@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* webViewConstraints;
@property (nonatomic) RUNAVideoState videoState;
@property (nonatomic) RUNAOpenRTBRequest* request;

@end


@implementation RUNABannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setInitState];
        self->_imp = [RUNABannerImp new];
        self.imp.json = [NSMutableDictionary new];
        if ([self conformsToProtocol:@protocol(RUNAOpenMeasurement)]
            && !self.openMeasurementDisabled) {
            self.imp.banner = @{ @"api": @[@(7)] };
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setInitState];
        self->_imp = [RUNABannerImp new];
        self.imp.json = [NSMutableDictionary new];
        if ([self conformsToProtocol:@protocol(RUNAOpenMeasurement)]
            && !self.openMeasurementDisabled) {
            self.imp.banner = @{ @"api": @[@(7)] };
        }
    }
    return self;
}

-(void) setInitState {
    self.hidden = YES;
    self.state = RUNA_ADVIEW_STATE_INIT;
    self.error = RUNABannerViewErrorNone;
    self.videoState = RUNA_VIDEO_STATE_UNKNOWN;
    self.mediaType = RUNA_MEDIA_TYPE_BANNER;
    [self.measurers enumerateObjectsUsingBlock:^(id<RUNAMeasurer>  _Nonnull measurer, NSUInteger idx, BOOL * _Nonnull stop) {
        [measurer finishMeasurement];
    }];
    self.measurers = [NSMutableArray new];
    self.logAdInfo = [RUNARemoteLogEntityAd new];
    self.logUserInfo = [RUNARemoteLogEntityUser new];
}

@synthesize state = _state;

-(void)setState:(RUNABannerViewState)state {
    self->_state = state;
    RUNADebug("set state %@", self.descriptionState);
}

-(RUNABannerViewState)state {
    return self->_state;
}

#pragma mark - APIs
-(BOOL)isLoading {
    RUNABannerViewState state = self.state;
    return state == RUNA_ADVIEW_STATE_LOADING
        || state == RUNA_ADVIEW_STATE_LOADED
        || state == RUNA_ADVIEW_STATE_RENDERING
        || state == RUNA_ADVIEW_STATE_MESSAGE_LISTENING;
}

-(void)load {
    [self loadWithEventHandler:nil];
}

-(void) loadWithEventHandler:(RUNABannerViewEventHandler)handler {
    RUNADebug("BannerView %p load: %@", self, self);
    
    if ([self isLoading]) {
        RUNALog("BannerView %p has started loading.", self);
        return;
    }

    RUNALog("BannerView %p has started loading.", self);
    
    [self setInitState];
    self.state = RUNA_ADVIEW_STATE_LOADING;
    self.eventHandler = handler;
    dispatch_async(RUNADefines.sharedInstance.sharedQueue, ^{
        @try {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                RUNALog("SDK RUNA/Banner Version: %@", self.class.versionString);
                RUNALog("%@", RUNADefines.sharedInstance);
            });
            
            if ([RUNAValid isEmptyString:self.adSpotId] && [RUNAValid isEmptyString:self.adSpotCode]) {
                NSLog(@"[RUNA] require adSpotId or adSpotCode!");
                self.error = RUNABannerViewErrorFatal;
                @throw [NSException exceptionWithName:@"init failed" reason:@"Both adSpotId & adSpotCode is empty" userInfo:nil];
            }

            RUNABannerAdapter* bannerAdapter = [RUNABannerAdapter new];
            bannerAdapter.impList = @[self.imp];
            bannerAdapter.appContent = self.appContent;
            bannerAdapter.userExt = self.userExt;
            bannerAdapter.userId = self.userId;
            bannerAdapter.geo = self.geo;
            bannerAdapter.responseConsumer = self;
            bannerAdapter.blockAdList = [self.session.blockAdList copy];
            RUNALog("block ad list for current session: %@", bannerAdapter.blockAdList);
            
            self.request = [RUNAOpenRTBRequest new];
            self.request.openRTBAdapterDelegate = bannerAdapter;

            [self.request resume];
        } @catch(NSException* exception) {
            RUNALog("load exception: %@", exception);
            if (self.error == RUNABannerViewErrorNone) {
                self.error = RUNABannerViewErrorInternal;
            }
            
            [self sendRemoteLogWithMessage:@"banner load exception" andException:exception];
            [self triggerFailure];
        }
    });
}

-(void)setAdSpotId:(NSString *)adSpotId {
    self.imp.adspotId = adSpotId;
}

- (NSString *)adSpotId {
    return self.imp.adspotId;
}

-(void)setAdSpotCode:(NSString *)adSpotCode {
    self.imp.adspotCode = adSpotCode;
}

-(NSString *)adSpotCode {
    return self.imp.adspotCode;
}

-(void)setAdSpotBranchId:(RUNABannerAdSpotBranch)adSpotBranchId {
    self.imp.adSpotBranchId = adSpotBranchId;
}

-(RUNABannerAdSpotBranch)adSpotBranchId {
    return self.imp.adSpotBranchId;
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
    self.imp.json = [NSMutableDictionary dictionaryWithDictionary:properties];
}

-(NSDictionary *)properties {
    return self.imp.json;
}

-(void) sendRemoteLogWithMessage:(NSString*) message andException:(NSException*) exception {
    RUNARemoteLogEntityErrorDetail* error = [RUNARemoteLogEntityErrorDetail new];
    error.errorMessage = [message stringByAppendingFormat:@": [%@] %@ { userInfo: %@ }", exception.name, exception.reason, exception.userInfo];
    error.stacktrace = exception.callStackSymbols;
    error.tag = @"RUNABanner";
    error.ext = self.descriptionDetail;
    
    // user info
    self.logUserInfo = nil;
    
    // ad info
    self.logAdInfo.adspotId = self.adSpotId;
    self.logAdInfo.sessionId = self.sessionId;
    self.logAdInfo.sdkVersion = self.class.RUNASDKVersionString;
    
    RUNARemoteLogEntity* log = [RUNARemoteLogEntity logWithError:error andUserInfo:self.logUserInfo adInfo:self.logAdInfo];
    [RUNARemoteLogger.sharedInstance sendLog:log];
}

#pragma mark - UI frame control
-(void)didMoveToSuperview {
    RUNADebug("didMoveToSuperview");
    if (self.superview) {
        [self applyContainerSize];
        [self applyContainerPosition];
        [self layoutIfNeeded];
    } else {
        RUNADebug("removeFromSuperview leads here when superview is nil");
    }
}

-(void)removeFromSuperview {
    RUNADebug("banner removeFromSuperview");
    [super removeFromSuperview];
}

-(void) applyContainerSize {
    if (self.superview && self.banner) {
        RUNADebug("applyContainerSize %lu", (unsigned long)self.size);

        [self.superview removeConstraints:self.sizeConstraints];
        [self removeConstraints:self.sizeConstraints];

        switch (self.size) {
            case RUNABannerViewSizeAspectFit:
                self->_sizeConstraints = @[[self.widthAnchor constraintEqualToAnchor:self.superview.widthAnchor],
                                           [self.heightAnchor constraintEqualToAnchor:self.widthAnchor multiplier:(self.banner.height / self.banner.width) constant:0.5],
                ];
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

        [self applyPositionWithSafeArea];

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

-(void) applyAdView {
    RUNADebug("apply applyView: %@", NSStringFromCGRect(self.frame));
    // remove old web view
    if (self.webView
        && self.webView.superview == self) {
        [self.webView removeFromSuperview];
    }
    
    // Web View
    self->_webView = [RUNAAdWebView new];
    self.webView.isSafeForBorder = !self.disableBorderAdjustment;
    [self.webView adjustAppearance];
    __weak typeof(self) weakSelf = self;

    RUNAAdWebViewMessageManager* messageManager = [[RUNAAdWebViewMessageManager alloc] initWithName:kSdkMessageHandlerName];
    [messageManager addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeExpand handle:^(RUNAAdWebViewMessage * _Nonnull message) {
        RUNADebug("handle [%@] %@", weakSelf.adSpotId, message.type);
        [weakSelf triggerSuccess];
    }]];
    [messageManager addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeCollapse handle:^(RUNAAdWebViewMessage * _Nonnull message) {
        RUNADebug("handle [%@] %@", weakSelf.adSpotId, message.type);
        [weakSelf triggerFailure];
    }]];
    [messageManager addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeRegister handle:^(RUNAAdWebViewMessage * _Nonnull message) {
        RUNADebug("handle [%@] %@", weakSelf.adSpotId, message.type);
        weakSelf.state = RUNA_ADVIEW_STATE_MESSAGE_LISTENING;
    }]];
    [messageManager addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeUnfilled handle:^(RUNAAdWebViewMessage * _Nonnull message) {
        RUNADebug("handle [%@] %@", weakSelf.adSpotId, message.type);
        weakSelf.error = RUNABannerViewErrorUnfilled;
        [weakSelf triggerFailure];
    }]];
    [messageManager addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeVideo handle:^(RUNAAdWebViewMessage * _Nonnull message) {
        RUNADebug("handle [%@] %@", weakSelf.adSpotId, message.type);
        weakSelf.mediaType = RUNA_MEDIA_TYPE_VIDEO;
    }]];
    [messageManager addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeVideoLoaded handle:^(RUNAAdWebViewMessage * _Nonnull message) {
        RUNADebug("handle [%@] %@", weakSelf.adSpotId, message.type);
        weakSelf.videoState = RUNA_VIDEO_STATE_LOADED;
    }]];
    [messageManager addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeClose handle:^(RUNAAdWebViewMessage * _Nonnull message) {
        RUNADebug("handle [%@] %@", weakSelf.adSpotId, message.type);
        if (weakSelf.eventHandler) {
            struct RUNABannerViewEvent event = { RUNABannerViewEventTypeInterstitialClosed, weakSelf.error };
            weakSelf.eventHandler(weakSelf, event);
        }
    }]];
    [messageManager addMessageHandler:[RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeJsError handle:^(RUNAAdWebViewMessage * _Nonnull message) {
        RUNADebug("handle [%@] %@", weakSelf.adSpotId, message.type);
        RUNALog("adspotId [%@] received js error: %@", weakSelf.adSpotId, message.message);
    }]];

    [self.webView.configuration.userContentController addScriptMessageHandler:messageManager name:kSdkMessageHandlerName];
    self.webView.navigationDelegate = self;
    [self addSubview:self.webView];
    
    NSString* html = self.banner.html;
    if ([self isOpenMeasurementAvailable]) {
        html = [(id<RUNAOpenMeasurement>)self injectOMProvider:self.banner.viewabilityProviderURL IntoHTML:html];
    }

    if (!self.iframeWebContentEnabled) {
        NSString* disableIframe = @"<script>window.renderWithoutIframe=true</script>";
        html = [disableIframe stringByAppendingString:html];
    }

    NSString* baseURLJs = [RUNAInfoPlist sharedInstance].baseURLJs ?: BASE_URL_RUNA_JS;
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:baseURLJs]];
    
    self.state = RUNA_ADVIEW_STATE_RENDERING;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self->_webViewConstraints = @[[self.webView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                                  [self.webView.topAnchor constraintEqualToAnchor:self.topAnchor],
                                  [self.webView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                                  [self.webView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
                                  ];
    [self addConstraints:self.webViewConstraints];
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

-(void)onBidResponseSuccess:(NSArray<RUNABanner*> *)adInfoList withSessionId:(NSString*) sessionId {
    @try {
        self->_sessionId = sessionId;
        self->_banner = [adInfoList firstObject];
        RUNADebug("onBidResponseSuccess: %@", self.banner);

        self.state = RUNA_ADVIEW_STATE_LOADED;

        if (!self.banner) {
            RUNALog("AdSpotInfo is empty");
            self.error = RUNABannerViewErrorInternal;
            @throw [NSException exceptionWithName:@"load failed" reason:@"banner info is empty" userInfo:@{@"RUNABanner": NSNull.null}];
        }

        if ([RUNAValid isEmptyString:self.banner.html]) {
            RUNALog("banner html is empty");
            self.error = RUNABannerViewErrorInternal;
            @throw [NSException exceptionWithName:@"load failed" reason:@"banner html is empty" userInfo:@{@"RUNABanner": self.banner}];
        }

        self->_designatedContentSize = CGSizeMake(self.banner.width, self.banner.height);

        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                [self applyAdView];
                [self applyContainerSize];
                [self applyContainerPosition];
                [self layoutIfNeeded];
            } @catch(NSException* exception) {
                RUNADebug("failed to render ad: %@", exception);
                if (self.error == RUNABannerViewErrorNone) {
                    self.error = RUNABannerViewErrorInternal;
                }
                [self sendRemoteLogWithMessage:@"failed to render ad" andException:exception];
                [self triggerFailure];
            }
        });
    } @catch(NSException* exception) {
        RUNADebug("failed to recognize ad response: %@", exception);
        if (self.error == RUNABannerViewErrorNone) {
            self.error = RUNABannerViewErrorInternal;
        }
        [self sendRemoteLogWithMessage:@"failed to recognize ad response" andException:exception];
        [self triggerFailure];
    }
}

- (nonnull RUNABanner*)parse:(nonnull NSDictionary *)bid {
    RUNABanner* banner = [RUNABanner new];
    [banner parse:bid];
    return banner;
}

-(BOOL)isFinished {
    return self.state == RUNA_ADVIEW_STATE_SHOWED || self.state == RUNA_ADVIEW_STATE_FAILED;
}

-(void) triggerSuccess {
    if ([self isFinished]) {
        return;
    }

    if ([self conformsToProtocol:@protocol(RUNADefaultMeasurement)]) {
        id<RUNAMeasurer> measurer = [(id<RUNADefaultMeasurement>)self getDefaultMeasurer];
        [measurer setMeasurerDelegate:self];
        [measurer startMeasurement];
        [self.measurers addObject:measurer];
    }

    self.state = RUNA_ADVIEW_STATE_SHOWED;
    if (self.banner.advertiseId > 0) {
        [self.session addBlockAd:self.banner.advertiseId];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        RUNADebug("triggerSuccess");
        self.hidden = NO;
        if (self.eventHandler) {
            @try {
                struct RUNABannerViewEvent event = { RUNABannerViewEventTypeSucceeded, self.error };
                self.eventHandler(self, event);
            } @catch (NSException* exception) {
                RUNALog("exception when bannerOnSucesss callback: %@", exception);
                [self sendRemoteLogWithMessage:@"exception when bannerOnSucesss callback" andException:exception];
            }
        }
    });
}

-(void) triggerFailure {
    if ([self isFinished]) {
        return;
    }

    self.state = RUNA_ADVIEW_STATE_FAILED;
    dispatch_async(dispatch_get_main_queue(), ^{
        RUNADebug("triggerFailure");
        @try {
            if (self.eventHandler) {
                struct RUNABannerViewEvent event = { RUNABannerViewEventTypeFailed, self.error };
                self.eventHandler(self, event);
            }
        } @catch(NSException* exception) {
            RUNALog("exception when bannerOnFailure callback: %@", exception);
            [self sendRemoteLogWithMessage:@"exception when bannerOnFailure callback:" andException:exception];
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
    RUNADebug("webview navigation type %@ decide for: %@",
              navigationAction.navigationType == WKNavigationTypeLinkActivated ? @"WKNavigationTypeLinkActivated" :
              navigationAction.navigationType == WKNavigationTypeOther ? @"WKNavigationTypeOther" :
              navigationAction.navigationType == WKNavigationTypeReload ? @"WKNavigationTypeReload" :
              navigationAction.navigationType == WKNavigationTypeBackForward ? @"WKNavigationTypeBackForward" :
              navigationAction.navigationType == WKNavigationTypeFormSubmitted ? @"WKNavigationTypeFormSubmitted" :
              navigationAction.navigationType == WKNavigationTypeFormResubmitted ? @"WKNavigationTypeFormResubmitted" :
              @"unknown"
              , navigationAction.request.URL.absoluteString);

    NSString* baseURLJs = [RUNAInfoPlist sharedInstance].baseURLJs ?: BASE_URL_RUNA_JS;
    NSURL* url = navigationAction.request.URL;
    if (url && navigationAction.targetFrame.isMainFrame) {
        if (navigationAction.navigationType == WKNavigationTypeLinkActivated // alternative 1 : click link
            || (navigationAction.navigationType == WKNavigationTypeOther // alternative 2: location change except internal Base URL
                && ![url.absoluteString isEqualToString:[baseURLJs stringByAppendingString:@"/"]]
                && ![url.absoluteString isEqualToString:BASE_URL_BLANK])
            ) {
            if (self.mediaType == RUNA_MEDIA_TYPE_VIDEO) {
                [self stopVideo];
            }

            if (self.eventHandler) {
                @try {
                    self->_clickURL = url.absoluteString;
                    struct RUNABannerViewEvent event = { RUNABannerViewEventTypeClicked, self.error };
                    self.eventHandler(self, event);
                } @catch (NSException *exception) {
                    RUNADebug("exception when bannerOnClick callback: %@", exception);
                    [self sendRemoteLogWithMessage:@"exception when bannerOnClick callback" andException:exception];
                }
            }

            if (!self.shouldPreventDefaultClickAction) {
                RUNADebug("clicked ad default action");
                [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success){
                    RUNADebug("opened AD URL");
                }];
            }
            RUNADebug("WKNavigationActionPolicyCancel");
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
                id<RUNAMeasurer> measurer = [(id<RUNAOpenMeasurement>)self getOpenMeasurer];
                [measurer startMeasurement];
                [self.measurers addObject:measurer];
            }
        } @catch (NSException *exception) {
            RUNADebug("exception when start measurement: %@", exception);
            [self sendRemoteLogWithMessage:@"exception when start measurement" andException:exception];
        }
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    RUNALog("AD view didFailNavigation %@", error);
}


# pragma mark - RUNAmeasurerDelegate method
-(BOOL)didMeasureImp:(BOOL)isImp {
    if (isImp && self.banner.measuredURL) {
        RUNADebug("measurement[default] measure imp (%p)", self);
        RUNAURLStringRequest* request = [RUNAURLStringRequest new];
        request.httpTaskDelegate = self.banner.measuredURL;
        [request resume];
    }
    return isImp;
}

- (BOOL)didMeasureInview:(BOOL)isInview {
    if (isInview) {
        [self sendMeasureInview];
    }

    return isInview;
}

- (BOOL)didMeasureVideoTrack:(BOOL)isInview {
    if (isInview) {
        [self playVideo];
    } else {
        [self pauseVideo];
    }
    return NO; // continue measurement
}

-(void)sendMeasureInview {
    if (self.banner.inviewURL) {
        RUNADebug("measurement[default] send inview %p", self);
        RUNAURLStringRequest* request = [RUNAURLStringRequest new];
        request.httpTaskDelegate = self.banner.inviewURL;
        [request resume];
    }
}


# pragma mark - Video Control Methods

- (void)playVideo {
    if (self.videoState == RUNA_VIDEO_STATE_LOADED || self.videoState == RUNA_VIDEO_STATE_PAUSED) {
        self.videoState = RUNA_VIDEO_STATE_PLAYING;
        RUNADebug("playVideo");
        [self notifyVideoViewableChanged:YES];
    }
}

- (void)pauseVideo {
    if (self.videoState == RUNA_VIDEO_STATE_PLAYING || self.videoState == RUNA_VIDEO_STATE_STOP) {
        self.videoState = RUNA_VIDEO_STATE_PAUSED;
        RUNADebug("pauseVideo");
        [self notifyVideoViewableChanged:NO];
    }
}

- (void)stopVideo {
    self.videoState = RUNA_VIDEO_STATE_STOP;
    [self notifyVideoViewableChanged:NO];
}

- (void)resumeVideo {
    self.videoState = RUNA_VIDEO_STATE_PLAYING;
    [self notifyVideoViewableChanged:YES];
}

- (void)notifyVideoViewableChanged:(BOOL)isInView {
    NSString *viewable = isInView ? @"true" : @"false";
    NSString *functionName = [NSString stringWithFormat:@"window.cd.sendViewable(%@)", viewable];
    [self.webView evaluateJavaScript:functionName
           completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        RUNADebug("evalute javascript: viewable %@", viewable);
        if (error) {
            RUNALog("video javascript evaluating error: %@", error);
        }
    }];
}

-(void)toggleVideoAdPlay:(BOOL)shouldPlay {
    if ((self.state == RUNA_ADVIEW_STATE_SHOWED)
        && self.mediaType == RUNA_MEDIA_TYPE_VIDEO) {
        RUNADebug("toggleVideoAdPlay: %@", shouldPlay ? @"YES" : @"NO");
        if (shouldPlay) {
            [self resumeVideo];
        } else {
            [self stopVideo];
        }
    }
}

# pragma mark - helping method
- (BOOL)isOpenMeasurementAvailable {
    return [self conformsToProtocol:@protocol(RUNAOpenMeasurement)]
    && !self.openMeasurementDisabled
    && self.banner.viewabilityProviderURL;
}

-(NSDictionary *) descriptionDetail {
    return @{
        @"adspotId" : self.adSpotId ?: NSNull.null,
        @"adspotCode" : self.adSpotCode ?: NSNull.null,
        @"adspotBranchId" : @(self.adSpotBranchId),
        @"userId(rp)" : self.userId ?: NSNull.null,
        @"state" : self.descriptionState,
        @"postion" : @(self.position),
        @"size" : @(self.size),
        @"properties" : self.properties ?: NSNull.null,
        @"appContent" : self.appContent ?: NSNull.null,
        @"geo" : self.geo ?: NSNull.null,
        @"user_extension" : self.userExt ?: NSNull.null,
        @"om_disabled" : self.openMeasurementDisabled ? @"YES" : @"NO",
        @"om_available" : self.isOpenMeasurementAvailable ? @"YES" : @"NO",
        @"iframe_enabled" : self.iframeWebContentEnabled ? @"YES" : @"NO",
    };
}

-(NSString *)description {
    return [NSString stringWithFormat: @"%@", self.descriptionDetail];
}

+(NSString*) versionString {
    return @OS_STRINGIFY(RUNA_SDK_VERSION);
}

/**
 * The version string identify the whole RUNA SDK.
 * It has the same value with the release version in the Podspec file
 * Any update in other modules brings update here.
 */
+(NSString*) RUNASDKVersionString {
    return @"1.14.0"; // TODO: check when release, latest check is 2023/07/04.
}

-(NSString*) descriptionState {
    return _state == RUNA_ADVIEW_STATE_INIT ? @"INIT" :
    _state == RUNA_ADVIEW_STATE_LOADING ? @"LOADING" :
    _state == RUNA_ADVIEW_STATE_LOADED ? @"LOADED" :
    _state == RUNA_ADVIEW_STATE_FAILED ? @"FAILED" :
    _state == RUNA_ADVIEW_STATE_RENDERING ? @"RENDERING":
    _state == RUNA_ADVIEW_STATE_MESSAGE_LISTENING ? @"MESSAGE_LISTENING":
    _state == RUNA_ADVIEW_STATE_SHOWED ? @"SHOWED" :
    @"unknown";
}


-(void)dealloc {
    RUNADebug("dealloc RUNABannerView %p: %@", self, self);
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kSdkMessageHandlerName];
    [self.measurers enumerateObjectsUsingBlock:^(id<RUNAMeasurer>  _Nonnull measurer, NSUInteger idx, BOOL * _Nonnull stop) {
        [measurer finishMeasurement];
    }];
}

@end
