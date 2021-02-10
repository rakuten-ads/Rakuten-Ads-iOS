//
//  RUNABannerViewExtension.h
//  RUNA
//
//  Created by Wu, Wei b on 2019/10/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUNABannerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNABannerViewGenreProperty : NSObject

@property(nonatomic, readonly) NSInteger masterId;
@property(nonatomic, readonly, copy) NSString* code;
@property(nonatomic, readonly, copy) NSString* match;

+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithMasterId:(NSInteger) masterId code:(NSString*) code match:(NSString*) match;

@end


@interface RUNABannerView(RUNA_Extension)

-(void) setPropertyGenre:(RUNABannerViewGenreProperty*) matchingGenre;
-(void) setCustomTargeting:(NSDictionary*) target;

/**
 set RzCookie
 */
-(void) setRz:(NSString*) rz;

/**
 set location with latitude and longitude values.
 @param lat double, from -90.0 to +90.0, where negative is south
 @param lon double, from -180.0 to +180.0, where negative is west
 */
-(void) setLocationWithLatitude:(double) lat longitude:(double) lon
NS_SWIFT_NAME(setLocation(latitude:longitude:));

@end

NS_ASSUME_NONNULL_END
