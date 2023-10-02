//
//  RUNABannerViewExtension.h
//  RUNA
//
//  Created by Wu, Wei b on 2019/10/28.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUNABanner/RUNABanner.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Define a genre with details.
 */
@interface RUNABannerViewGenreProperty : NSObject

@property(nonatomic, readonly) NSInteger masterId;
@property(nonatomic, readonly, copy) NSString* code;
@property(nonatomic, readonly, copy) NSString* match;

+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithMasterId:(NSInteger) masterId code:(NSString*) code match:(NSString*) match;

@end

/*!
 Extension for certain properties.
 */
@interface RUNABannerView(RUNA_Extension)

/*!
 indicate targeting genre
 @param matchingGenre genre details
 */
-(void) setPropertyGenre:(RUNABannerViewGenreProperty*) matchingGenre;

/*!
 indicate custom targeting
 @param target target details
 */
-(void) setCustomTargeting:(NSDictionary*) target;

/*!
 set RzCookie
 @param rz value of the RzCookie
 */
-(void) setRz:(NSString*) rz;

/*!
 set RpCookie
 @param rp value of the RpCookie
 */
-(void) setRp:(NSString*) rp;

/*!
 set easyId
 @param easyId value of the easyId
 */
-(void) setEasyId:(NSString*) easyId;

/*!
 set rpoint
 @param rpoint value of the rpoint
 */
-(void) setRpoint:(NSInteger) rpoint;

/*!
 set location with latitude and longitude values.
 @param lat double, from -90.0 to +90.0, where negative is south
 @param lon double, from -180.0 to +180.0, where negative is west
 */
-(void) setLocationWithLatitude:(double) lat longitude:(double) lon
NS_SWIFT_NAME(setLocation(latitude:longitude:));

@end

NS_ASSUME_NONNULL_END
