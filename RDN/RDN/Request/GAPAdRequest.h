//
//  GAPAdRequest.h
//  RsspSDK
//
//  Created by Wu Wei on 2018/07/24.
//  Copyright © 2018 LOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GAPCore/GAPHttpSession.h>
#import "GAPAdSpotInfo.h"

@protocol GAPAdRequestDelegate

-(void)adRequestOnSuccess:(nonnull GAPAdSpotInfo*) adSpotInfo;
-(void)adRequestOnFailure;

@end

@interface GAPAdRequest : GAPHttpSession <GAPJsonHttpSessionDelegate>

@property(nonatomic, readonly, nonnull) NSString* adSpotId;
@property(nonatomic, nullable) id<GAPAdRequestDelegate> delegate;

-(instancetype)initWithAdSpotId:(nonnull NSString*) adSpotId;

-(instancetype)init __unavailable;
+(instancetype)new __unavailable;

@end
