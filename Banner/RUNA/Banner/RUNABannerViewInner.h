//
//  RUNABannerViewInner.h
//  RUNA
//
//  Created by Wu, Wei b on 2019/09/02.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#ifndef RUNABannerViewInner_h
#define RUNABannerViewInner_h

#ifndef RUNABannerView_h
#import "RUNABannerView.h"
#endif

#import "RUNAAdSessionInner.h"
#import "RUNABannerAdapter.h"
#import <RUNACore/RUNAValid.h>
#import <RUNACore/RUNAAdWebView.h>
#import <RUNACore/RUNADefines.h>
#import <RUNACore/RUNAInfoPlist.h>
#import <RUNACore/RUNAAdWebViewMessage.h>
#import <RUNACore/RUNARemoteLogger.h>
#import <RUNACore/RUNARemoteLogEntity.h>
#import "RUNAMeasurement.h"

NS_ASSUME_NONNULL_BEGIN

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

typedef NS_ENUM(NSUInteger, RUNAVideoState) {
    RUNA_VIDEO_STATE_UNKNOWN,
    RUNA_VIDEO_STATE_LOADED,
    RUNA_VIDEO_STATE_PLAYING,
    RUNA_VIDEO_STATE_PAUSED,
};

typedef NS_ENUM(NSUInteger, RUNAMediaType) {
    RUNA_MEDIA_TYPE_UNKOWN,
    RUNA_MEDIA_TYPE_BANNER,
    RUNA_MEDIA_TYPE_VIDEO,
};

typedef void (^RUNABannerViewEventHandler)(RUNABannerView* view, struct RUNABannerViewEvent event);

@interface RUNABannerView() <RUNABidResponseConsumerDelegate>

/*
 inner properties
 */
@property (nonatomic, nullable, copy) RUNABannerViewEventHandler eventHandler;
@property (nonatomic, readonly, nullable) RUNAAdWebView* webView;
@property (nonatomic, readonly, nullable) RUNABanner* banner;
@property (nonatomic, readonly, nullable) NSString* sessionId;
@property (nonatomic, nullable) NSMutableArray<id<RUNAMeasurer>> *measurers;
@property (nonatomic) RUNABannerViewError error;
@property (nonatomic, readonly) RUNABannerImp* imp;
@property (nonatomic) NSString* uuid;

/*
 external options
 */
@property (nonatomic, nullable) NSDictionary* appContent;
@property (nonatomic, nullable) NSDictionary* userExt; /* include rzCookie */
@property (nonatomic) BOOL openMeasurementDisabled;
@property (nonatomic) BOOL iframeWebContentEnabled;
@property (nonatomic, nullable) RUNAGeo* geo;

/*
 log
 */
@property (nonatomic, nullable) RUNARemoteLogEntityAd* logAdInfo;
@property (nonatomic, nullable) RUNARemoteLogEntityUser* logUserInfo;

-(void) sendRemoteLogWithMessage:(NSString*) message andException:(NSException*) exception;

-(BOOL) isOpenMeasurementAvailable;

-(NSDictionary*) descriptionDetail;

@end

NS_ASSUME_NONNULL_END

#endif /* RUNABannerViewInner_h */
