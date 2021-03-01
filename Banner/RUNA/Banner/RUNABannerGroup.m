//
//  RUNABannerGroup.m
//  Banner
//
//  Created by Wu, Wei | David on 2021/02/19.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNABannerGroup.h"
#import "RUNABannerViewInner.h"

typedef void (^RUNABannerGroupEventHandler)(RUNABannerGroup* group, RUNABannerView* __nullable view, struct RUNABannerViewEvent event);

@interface RUNABannerGroup() <RUNABidResponseConsumerDelegate>

@property (nonatomic, nullable, copy) RUNABannerGroupEventHandler eventHandler;
@property (nonatomic, nullable) NSMutableDictionary* jsonProperties;
@property (atomic, readonly) RUNABannerViewState state;
@property (nonatomic) RUNABannerViewError error;

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
    RUNADebug("set state %@", self.descriptionState);
}

-(RUNABannerViewState)state {
    return self->_state;
}

-(void)load {
    [self loadWithEventHandler:nil];
}

-(void)loadWithEventHandler:(void (^)(RUNABannerGroup * _Nonnull, RUNABannerView * _Nullable, struct RUNABannerViewEvent))handler {
    self.eventHandler = handler;
    dispatch_async(RUNADefines.sharedInstance.sharedQueue, ^{
        @try {
            NSMutableArray<RUNABannerImp*>* impList = [NSMutableArray array];
            for (RUNABannerView* bannerView in self.banners) {
                if ([RUNAValid isEmptyString:bannerView.adSpotId]) {
                    NSLog(@"[RUNA] require adSpotId!");
                    self.error = RUNABannerViewErrorFatal;
                    @throw [NSException exceptionWithName:@"init failed" reason:@"adSpotId is empty" userInfo:nil];
                }

                [impList addObject:bannerView.imp];
                bannerView.eventHandler = ^(RUNABannerView * _Nonnull view, struct RUNABannerViewEvent event) {
                    self.eventHandler(self, view, event);
                };
            }

            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                RUNALog("SDK RUNA/Banner Version: %@", self.versionString);
                RUNALog("%@", RUNADefines.sharedInstance);
            });

            RUNABannerAdapter* bannerAdapter = [RUNABannerAdapter new];
            bannerAdapter.impList = impList;
            bannerAdapter.responseConsumer = self;

            RUNAOpenRTBRequest* request = [RUNAOpenRTBRequest new];
            request.openRTBAdapterDelegate = bannerAdapter;

            [request resume];

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


- (void)onBidResponseFailed:(nonnull NSHTTPURLResponse *)response error:(nullable NSError *)error {
    RUNALog("Group load failed %@", error);
    if (response.statusCode == kRUNABidResponseUnfilled) {
        self.error = RUNABannerViewErrorUnfilled;
    } else if (error) {
        self.error = RUNABannerViewErrorNetwork;
    }
    [self triggerFailure];
}

- (void)onBidResponseSuccess:(nonnull NSArray<id<RUNAAdInfo>> *)adInfoList withSessionId:(nonnull NSString *)sessionId {
    for (int i = 0; i < MIN(adInfoList.count, self.banners.count); i++) {
        [self.banners[i] onBidResponseSuccess:@[adInfoList[i]] withSessionId:sessionId];
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
                struct RUNABannerViewEvent event = { RUNABannerViewEventTypeFailed, self.error };
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

@end
