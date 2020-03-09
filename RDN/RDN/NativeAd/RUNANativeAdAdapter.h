//
//  RUNANativeAdAdapter.h
//  RDN
//
//  Created by Wu, Wei b on 2019/03/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUNABidAdapter.h"


NS_ASSUME_NONNULL_BEGIN

@interface RUNANativeAdAdapter : RUNABidAdapter

@property(nonatomic, copy) NSString* adspotId;

@end

NS_ASSUME_NONNULL_END
