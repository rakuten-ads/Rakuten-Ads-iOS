//
//  RPSBannerViewIchiba.h
//  RDN
//
//  Created by Wu, Wei b on 2019/10/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSBannerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPSBannerViewGenreProperty : NSObject

@property(nonatomic, readonly) NSInteger masterId;
@property(nonatomic, readonly, copy) NSString* code;
@property(nonatomic, readonly, copy) NSString* match;

+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithMasterId:(NSInteger) masterId code:(NSString*) code match:(NSString*) match;

@end


@interface RPSBannerView(RPS_Ichiba)

-(void) setPropertyGenre:(RPSBannerViewGenreProperty*) matchingGenre;
-(void) setPropertyTargeting:(NSDictionary*) target;

@end

NS_ASSUME_NONNULL_END
