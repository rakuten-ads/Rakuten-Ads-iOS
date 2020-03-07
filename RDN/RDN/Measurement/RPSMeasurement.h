//
//  RPSMeasurement.h
//  RDN
//
//  Created by Wu, Wei b on 2019/08/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RPSMeasurable <NSObject>

@end

@protocol RPSMeasurer <NSObject>

-(void) setMeasureTarget:(id<RPSMeasurable>) target;
-(void) startMeasurement;
-(void) finishMeasurement;

@end

#pragma mark - default measurement

@protocol RPSDefaultMeasurement <RPSMeasurable>

-(id<RPSMeasurer>) getDefaultMeasurer;
-(BOOL) measureImp;
-(BOOL) measureInview;

@end

@interface RPSDefaultMeasurer: NSOperation <RPSMeasurer>

@end

#pragma mark - open measurement

@protocol RPSOpenMeasurement <RPSMeasurable>

-(id<RPSMeasurer>) getOpenMeasurer;

@end


NS_ASSUME_NONNULL_END
