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

@interface RPSBannerView()

@property (nonatomic, readonly, nullable) RPSBanner* banner;
@property (nonatomic, nullable) NSMutableDictionary* jsonProperties;

@end

NS_ASSUME_NONNULL_END

#endif /* RPSBannerViewInner_h */
