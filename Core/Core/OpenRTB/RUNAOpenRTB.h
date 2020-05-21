//
//  RUNAOpenRTB.h
//  RUNA
//
//  Created by Wu, Wei b on 2019/02/26.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUNACore/RUNAHttpTask.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RUNAOpenRTBProtocol<RUNAJsonHttpSessionDelegate>

-(NSDictionary*) postBidBody;

@end

@protocol RUNAOpenRTBAdapterDelegate <NSObject>

-(NSArray*) getImp;
-(NSDictionary*) getApp;

-(NSString*) getURL;
-(void) onBidResponse:(NSHTTPURLResponse*) response withBidList:(NSArray*) bidList;

@optional
-(void) processBidBody:(NSMutableDictionary*) bidBody;

@end

@interface RUNAOpenRTBRequest : RUNAHttpTask<RUNAOpenRTBProtocol>

@property(nonatomic, strong) id<RUNAOpenRTBAdapterDelegate> openRTBAdapterDelegate;

@end

NS_ASSUME_NONNULL_END
