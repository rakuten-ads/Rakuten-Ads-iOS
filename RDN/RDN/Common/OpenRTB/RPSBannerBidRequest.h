//
//  RPSBannerBidRequest.h
//  RDN
//
//  Created by Wu, Wei b on 2019/02/21.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSOpenRTBRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPSBannerBidRequest : RPSBidRequest<RPSBidRequestDelegate>

@property(nonatomic, readonly) NSString* adspotId;

@end

NS_ASSUME_NONNULL_END
