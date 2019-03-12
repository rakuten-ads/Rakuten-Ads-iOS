//
//  RPSOpenRTB.h
//  RDN
//
//  Created by Wu, Wei b on 2019/02/26.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RPSCore/RPSHttpSession.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RPSOpenRTBProtocol<RPSJsonHttpSessionDelegate>

-(NSDictionary*) postBidBody;

@end

@protocol RPSOpenRTBBuildDelegate <NSObject>

-(NSArray*) getImp;

-(NSString*) getURL;
-(void) onBidResponse:(NSHTTPURLResponse*) response withBidList:(NSArray*) bidList;

@optional
-(void) processBidBody:(NSMutableDictionary*) bidBody;

@end

@interface RPSOpenRTBRequest : RPSHttpSession<RPSOpenRTBProtocol>

@property(nonatomic, strong) id<RPSOpenRTBBuildDelegate> openRTBdelegate;

@end

NS_ASSUME_NONNULL_END
