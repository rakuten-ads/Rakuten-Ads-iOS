//
//  RPSMeasurement.h
//  RDN
//
//  Created by Wu, Wei b on 2019/08/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSBannerView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RPSMeasurableDelegate <NSObject>

-(BOOL) measureImp;
-(BOOL) measureInview;

@end

@interface RPSMeasurement: NSOperation

@property(nonatomic, assign, nullable) id<RPSMeasurableDelegate> measurableTarget;

-(void) startMeasurement;

@end

NS_ASSUME_NONNULL_END
