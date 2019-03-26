//
//  RPSNativeAdsImpRequest.h
//  RDN
//
//  Created by Wu, Wei b on 2019/03/25.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSCore/RPSHttpTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPSNativeAdsImpRequest : RPSHttpTask<RPSHttpTaskDelegate>

@property(nonatomic, copy) NSString* impLink;

@end

NS_ASSUME_NONNULL_END
