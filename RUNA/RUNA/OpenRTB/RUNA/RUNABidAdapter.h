//
//  RUNABidRequestAdapter.h
//  RUNA
//
//  Created by Wu, Wei b on 2019/02/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUNAOpenRTB.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RUNAAdInfo <NSObject>

@end

@protocol RUNABidResponseConsumerDelegate <NSObject>

-(id<RUNAAdInfo>) parse:(NSDictionary*) bid;

-(void) onBidResponseSuccess:(NSArray<id<RUNAAdInfo>>*) adInfoList;
-(void) onBidResponseFailed;

@end

@interface RUNABidAdapter : NSObject<RUNAOpenRTBAdapterDelegate>

@property(nonatomic, weak) id<RUNABidResponseConsumerDelegate> responseConsumer;

@end

NS_ASSUME_NONNULL_END
