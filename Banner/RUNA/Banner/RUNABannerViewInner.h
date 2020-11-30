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

#import "RUNABannerAdapter.h"
#import <RUNACore/RUNAValid.h>
#import <RUNACore/RUNAAdWebView.h>
#import <RUNACore/RUNADefines.h>
#import <RUNACore/RUNAInfoPlist.h>
#import <RUNACore/RUNAAdWebViewMessage.h>
#import "RUNAMeasurement.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^RUNABannerViewEventHandler)(RUNABannerView* view, struct RUNABannerViewEvent event);

@interface RUNABannerView()

@property (nonatomic, nullable, copy) RUNABannerViewEventHandler eventHandler;
@property (nonatomic, readonly, nullable) RUNAAdWebView* webView;
@property (nonatomic, readonly, nullable) RUNABanner* banner;
@property (nonatomic, nullable) NSMutableDictionary* jsonProperties;
@property (nonatomic, nullable) NSMutableDictionary* appContent;
@property (nonatomic, nullable) RUNAAdWebViewMessageHandler* openPopupHandler;
@property (nonatomic, nullable) NSMutableArray<id<RUNAMeasurer>> *measurers;
@property (nonatomic) RUNABannerViewError error;
@property (nonatomic) BOOL openMeasurementDisabled;

@property (nonatomic) BOOL iframeWebContentEnabled;

@end

NS_ASSUME_NONNULL_END

#endif /* RUNABannerViewInner_h */
