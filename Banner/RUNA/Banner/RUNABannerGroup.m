//
//  RUNABannerGroup.m
//  Banner
//
//  Created by Wu, Wei | David on 2021/02/19.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNABannerGroupInner.h"

typedef void (^RUNABannerGroupEventHandler)(RUNABannerGroup* group, RUNABannerView* __nullable view, struct RUNABannerViewEvent event);

@interface RUNABannerGroup() <RUNABidResponseConsumerDelegate>

@property (nonatomic) NSDictionary<NSString*, RUNABannerView*>* bannerDict;
@property (nonatomic, nullable, copy) RUNABannerGroupEventHandler eventHandler;
@property (nonatomic, nullable) NSMutableDictionary* jsonProperties;
@property (nonatomic) RUNABannerViewError error;
@property (nonatomic) int loadedBannerCounter;

@end

@implementation RUNABannerGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.state = RUNA_ADVIEW_STATE_INIT;
    }
    return self;
}

@synthesize state = _state;

-(void)setState:(RUNABannerViewState)state {
    self->_state = state;
    RUNADebug("group set state %@", self.descriptionState);
}

-(RUNABannerViewState)state {
    return self->_state;
}

-(void)load {
    [self loadWithEventHandler:nil];
}

-(void)setBanners:(NSArray<RUNABannerView *> *)banners {
    NSMutableDictionary* bannerDict = [NSMutableDictionary dictionary];
    for (RUNABannerView* bannerView in banners) {
        bannerView.imp.id = NSUUID.UUID.UUIDString;
        [bannerDict setObject:bannerView forKey:bannerView.imp.id];
    }
    self->_bannerDict = bannerDict;
}

-(NSArray<RUNABannerView *> *)banners {
    return _bannerDict.allValues;
}

-(void)loadWithEventHandler:(void (^)(RUNABannerGroup * _Nonnull, RUNABannerView * _Nullable, struct RUNABannerViewEvent))handler {
    RUNADebug("banner group %p load: %@", self, self);
    if (self.state == RUNA_ADVIEW_STATE_LOADING
        || self.state == RUNA_ADVIEW_STATE_LOADED) {
        RUNALog("banner group %p has started loading.", self);
        return;
    }

    if (self.bannerDict.count == 0) {
        NSLog(@"[RUNA] banner group must not be empty!");
        return;
    }

    self.eventHandler = handler;
    self.state = RUNA_ADVIEW_STATE_LOADING;
    dispatch_async(RUNADefines.sharedInstance.sharedQueue, ^{
        @try {
            NSMutableArray<RUNABannerImp*>* impList = [NSMutableArray array];
            for (RUNABannerView* bannerView in self.bannerDict.allValues) {
                if ([RUNAValid isEmptyString:bannerView.adSpotId]) {
                    NSLog(@"[RUNA] each banner requires adSpotId!");
                    self.error = RUNABannerViewErrorFatal;
                    @throw [NSException exceptionWithName:@"group init failed" reason:@"adSpotId is empty" userInfo:nil];
                }

                [impList addObject:bannerView.imp];
                if (handler) {
                    __weak typeof(self) weakSelf = self;
                    bannerView.eventHandler = ^(RUNABannerView * _Nonnull view, struct RUNABannerViewEvent event) {
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        if (!strongSelf) {
                            RUNADebug("banner group: banner view disposed!");
                            return;
                        }
                        strongSelf.eventHandler(strongSelf, view, event);
                        strongSelf.loadedBannerCounter++;
                        RUNADebug("banner (%d/%lu) loaded", strongSelf.loadedBannerCounter, (unsigned long)strongSelf.banners.count);
                        if (strongSelf.loadedBannerCounter == strongSelf.banners.count) {
                            RUNADebug("banner group finished");
                            struct RUNABannerViewEvent groupFinishedEvent = { RUNABannerViewEventTypeGroupFinished, RUNABannerViewErrorNone };
                            strongSelf.eventHandler(strongSelf, nil, groupFinishedEvent);
                        }
                    };
                }
            }

            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                RUNALog("SDK RUNA/Banner Version: %@", self.versionString);
                RUNALog("%@", RUNADefines.sharedInstance);
            });

            RUNABannerAdapter* bannerAdapter = [RUNABannerAdapter new];
            bannerAdapter.impList = impList;
            bannerAdapter.userExt = self.userExt;
            bannerAdapter.responseConsumer = self;

            RUNAOpenRTBRequest* request = [RUNAOpenRTBRequest new];
            request.openRTBAdapterDelegate = bannerAdapter;

            [request resume];

        } @catch(NSException* exception) {
            RUNALog("group load exception: %@", exception);
            if (self.error == RUNABannerViewErrorNone) {
                self.error = RUNABannerViewErrorInternal;
            }

            [self sendRemoteLogWithMessage:@"group banner load exception" andException:exception];
            [self triggerFailure];
        }
    });

}

- (void)onBidResponseFailed:(nonnull NSHTTPURLResponse *)response error:(nullable NSError *)error {
    RUNALog("group load failed %@", error);
    if (response.statusCode == kRUNABidResponseUnfilled) {
        self.error = RUNABannerViewErrorUnfilled;
    } else if (error) {
        self.error = RUNABannerViewErrorNetwork;
    }
    [self triggerFailure];
}

- (void)onBidResponseSuccess:(nonnull NSArray<RUNABanner*> *)adInfoList withSessionId:(nonnull NSString *)sessionId {
    self.state = RUNA_ADVIEW_STATE_LOADED;
    for (RUNABanner* bannerInfo in adInfoList) {
        RUNABannerView* bannerView = self.bannerDict[bannerInfo.impId];
        if (bannerView) {
            [bannerView onBidResponseSuccess:@[bannerInfo] withSessionId:sessionId];
        } else {
            RUNADebug("unmatch impid %@", bannerInfo.impId);
        }
    }
}

- (nonnull id<RUNAAdInfo>)parse:(nonnull NSDictionary *)bid {
    RUNABanner* banner = [RUNABanner new];
    [banner parse:bid];
    return banner;
}

-(void) triggerFailure {
    if (self.state == RUNA_ADVIEW_STATE_FAILED || self.state == RUNA_ADVIEW_STATE_SHOWED) {
        return;
    }

    self.state = RUNA_ADVIEW_STATE_FAILED;
    dispatch_async(dispatch_get_main_queue(), ^{
        RUNADebug("triggerFailure");
        @try {
            if (self.eventHandler) {
                struct RUNABannerViewEvent event = { RUNABannerViewEventTypeGroupFailed, self.error };
                self.eventHandler(self, nil, event);
            }
        } @catch(NSException* exception) {
            RUNALog("exception when bannerOnFailure callback: %@", exception);
            [self sendRemoteLogWithMessage:@"exception when bannerOnFailure callback:" andException:exception];
        }
    });
}

-(void) sendRemoteLogWithMessage:(NSString*) message andException:(NSException*) exception {
    RUNARemoteLogEntityErrorDetail* error = [RUNARemoteLogEntityErrorDetail new];
    error.errorMessage = [message stringByAppendingFormat:@": [%@] %@ { userInfo: %@ }", exception.name, exception.reason, exception.userInfo];
    error.stacktrace = exception.callStackSymbols;
    error.tag = @"RUNABannerGroup";

    NSMutableArray<NSDictionary*>* bannerDetails = [NSMutableArray array];
    [self.banners enumerateObjectsUsingBlock:^(RUNABannerView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [bannerDetails addObject:obj.descriptionDetail];
    }];
    error.ext = @{
        @"group" : self.descriptionDetail,
        @"banners" : bannerDetails
    };

    RUNARemoteLogEntity* log = [RUNARemoteLogEntity logWithError:error andUserInfo:nil adInfo:nil];
    [RUNARemoteLogger.sharedInstance sendLog:log];
}

-(NSString*) descriptionState {
    return _state == RUNA_ADVIEW_STATE_INIT ? @"INIT" :
    _state == RUNA_ADVIEW_STATE_LOADING ? @"LOADING" :
    _state == RUNA_ADVIEW_STATE_LOADED ? @"LOADED" :
    _state == RUNA_ADVIEW_STATE_FAILED ? @"FAILED" :
    _state == RUNA_ADVIEW_STATE_RENDERING ? @"RENDERING":
    _state == RUNA_ADVIEW_STATE_MESSAGE_LISTENING ? @"MESSAGE_LISTENING":
    _state == RUNA_ADVIEW_STATE_SHOWED ? @"SHOWED" :
    _state == RUNA_ADVIEW_STATE_CLICKED ? @"CLICKED" : @"unknown";
}

-(NSString*) versionString {
    return [[[NSBundle bundleForClass:self.class] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

-(NSDictionary *) descriptionDetail {
    return @{
        @"banners" : self.banners ?: NSNull.null,
        @"state" : self.descriptionState,
        @"user_extension" : self.userExt ?: NSNull.null,
    };
}

-(NSString *)description {
    return [NSString stringWithFormat: @"%@", self.descriptionDetail];
}

@end
