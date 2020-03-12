//
//  RUNABannerViewInner.h
//  RUNA
//
//  Created by Wu, Wei b on 2019/09/02.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#ifndef RUNABannerViewInner_h
#define RUNABannerViewInner_h

#import "RUNABannerView.h"
#import "RUNAAdWebView.h"
#import "RUNABannerAdapter.h"
#import <RUNACore/RUNAValid.h>
#import "RUNADefines.h"
#import "RUNAAdWebViewMessage.h"
#import "RUNAMeasurement.h"

NS_ASSUME_NONNULL_BEGIN


@interface RUNABannerView()

@property (nonatomic, readonly, nullable) RUNAAdWebView* webView;
@property (nonatomic, readonly, nullable) RUNABanner* banner;
@property (nonatomic, nullable) NSMutableDictionary* jsonProperties;
@property (nonatomic, nullable) NSMutableDictionary* appContent;
@property (nonatomic, nullable) RUNAAdWebViewMessageHandler* openPopupHandler;
@property (nonatomic, nullable) id<RUNAMeasurer> measurer;

@end

NS_ASSUME_NONNULL_END

#endif /* RUNABannerViewInner_h */
