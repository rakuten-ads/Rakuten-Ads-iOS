//
//  RPSOpenRTBRequest.h
//  RDN
//
//  Created by Wu, Wei b on 2019/02/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RPSCore/RPSHttpSession.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * OpenRTB specs protocol
 */
@protocol RPSOpenRTBRequestBuildDelegate <RPSJsonHttpSessionDelegate>

-(NSArray*) getImp;
-(NSDictionary*) getApp;
-(NSDictionary*) getDevice;

@end


/**
 * RPS SSP specs protocol
 */
@protocol RPSBidRequestDelegate <NSObject>

-(NSArray<NSString*>*) getAdspotIdList;

@optional
-(NSArray*) preferImp;

@end

/**
 * common request for RPS specs with OpenRTB
 */
@interface RPSBidRequest : RPSHttpSession<RPSOpenRTBRequestBuildDelegate>

@property (nonatomic, readonly) NSArray* imp;
@property (nonatomic, readonly) NSDictionary* app;
@property (nonatomic, readonly) NSDictionary* device;

@property (nonatomic, copy) id<RPSBidRequestDelegate> bidRequestDelegate;

@end

NS_ASSUME_NONNULL_END
