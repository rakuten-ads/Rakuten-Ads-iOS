//
//  RPSNativeAdsAdapter.h
//  RDN
//
//  Created by Wu, Wei b on 2019/03/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSBidAdapter.h"
#import "RPSNativeAdsRequest.h"


NS_ASSUME_NONNULL_BEGIN

@interface RPSNativeAdsAdapter : RPSBidAdapter

@property(nonatomic, copy) NSString* adspotId;

@end

NS_ASSUME_NONNULL_END
