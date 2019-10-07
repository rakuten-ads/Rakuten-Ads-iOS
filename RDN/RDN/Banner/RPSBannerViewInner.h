//
//  RPSBannerViewInner.h
//  RDN
//
//  Created by Wu, Wei b on 2019/09/02.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#ifndef RPSBannerViewInner_h
#define RPSBannerViewInner_h

#import "RPSBannerView.h"
#import "RPSAdWebView.h"
#import "RPSBannerAdapter.h"
#import <RPSCore/RPSValid.h>
#import "RPSDefines.h"
#import "RPSMeasurement.h"

NS_ASSUME_NONNULL_BEGIN

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

@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* sizeConstraints;
@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* positionConstraints;
@property (nonatomic, readonly) NSArray<NSLayoutConstraint*>* webViewConstraints;
@property (nonatomic, readonly, nullable) RPSAdWebView* webView;
@property (nonatomic, nullable, copy) RPSBannerViewEventHandler eventHandler;
@property (atomic, readonly) RPSBannerViewState state;
@property (nonatomic, readonly, nullable) RPSBanner* banner;
@property (nonatomic, nullable) RPSMeasurement* measurement;

@end

NS_ASSUME_NONNULL_END

#endif /* RPSBannerViewInner_h */
