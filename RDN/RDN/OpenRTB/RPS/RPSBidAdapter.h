//
//  RPSBidRequestAdapter.h
//  RDN
//
//  Created by Wu, Wei b on 2019/02/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSOpenRTB.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RPSAdInfo <NSObject>

@end

@protocol RPSBidResponseConsumer <NSObject>

-(id<RPSAdInfo>) parse:(NSDictionary*) bid;
-(void) onBidResponseSuccess:(NSArray<id<RPSAdInfo>>*) adInfoList;
-(void) onBidResponseFailed;

@end

@interface RPSBidAdapter : NSObject<RPSOpenRTBAdapterDelegate>

@property(nonatomic, copy) NSArray<NSString*>* adspotIdList;
@property(nonatomic, assign) id<RPSBidResponseConsumer> responseConsumer;

@end

NS_ASSUME_NONNULL_END
