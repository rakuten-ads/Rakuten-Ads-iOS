//
//  RPSAdRequest.h
//  RsspSDK
//
//  Created by Wu Wei on 2018/07/24.
//  Copyright © 2018 LOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RPSCore/RPSHttpSession.h>
#import "RPSAdSpotInfo.h"

@protocol RPSAdRequestDelegate

-(void)adRequestOnSuccess:(nonnull RPSAdSpotInfo*) adSpotInfo;
-(void)adRequestOnFailure;

@end

@interface RPSAdRequest : RPSHttpSession <RPSJsonHttpSessionDelegate>

@property(nonatomic, readonly, nonnull) NSString* adSpotId;
@property(nonatomic, nullable) id<RPSAdRequestDelegate> delegate;

-(instancetype)initWithAdSpotId:(nonnull NSString*) adSpotId;

-(instancetype)init __unavailable;
+(instancetype)new __unavailable;

@end
