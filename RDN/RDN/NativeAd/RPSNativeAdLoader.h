//
//  RPSNativeAd.h
//  RDN
//
//  Created by Wu, Wei b on 2019/03/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RPSNativeAdAssetImage;

NS_ASSUME_NONNULL_BEGIN

@interface RPSNativeAdLoader: NSObject

@property(nonatomic, copy, nonnull) NSString* adSpotId;

-(instancetype) initWithAdSpotId:(NSString*) adSpotId;

-(instancetype) init NS_UNAVAILABLE;
+(instancetype) new NS_UNAVAILABLE;

-(void) loadWithCompletionHandler:(nullable BOOL (^)(RPSNativeAdLoader* loader, NSArray<RPSNativeAd*>* adsList)) handler;

@end

NS_ASSUME_NONNULL_END
