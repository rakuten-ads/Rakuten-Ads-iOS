//
//  RPSOpenRTB.h
//  RDN
//
//  Created by Wu, Wei b on 2019/02/26.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RPSCore/RPSHttpTask.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RPSOpenRTBProtocol<RPSJsonHttpSessionDelegate>

-(NSDictionary*) postBidBody;

@end

@protocol RPSOpenRTBAdapterDelegate <NSObject>

-(NSArray*) getImp;
-(NSDictionary*) getApp;

-(NSString*) getURL;
-(void) onBidResponse:(NSHTTPURLResponse*) response withBidList:(NSArray*) bidList;

@optional
-(void) processBidBody:(NSMutableDictionary*) bidBody;

@end

@interface RPSOpenRTBRequest : RPSHttpTask<RPSOpenRTBProtocol>

@property(nonatomic, strong) id<RPSOpenRTBAdapterDelegate> openRTBAdapterDelegate;

@end

NS_ASSUME_NONNULL_END
