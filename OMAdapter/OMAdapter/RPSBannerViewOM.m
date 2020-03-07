//
//  RPSBannerViewOM.m
//  OMAdapter
//
//  Created by Wu, Wei b on R 2/03/06.
//  Copyright © Reiwa 2 RPS. All rights reserved.
//

#import "RPSBannerViewInner.h"
#import "RPSOpenMeasurer.h"

@interface RPSBannerView(OMSDK)<RPSOpenMeasurement>

@end

@implementation RPSBannerView(OMSDK)

-(id<RPSMeasurer>) getOpenMeasurer {
    RPSOpenMeasurer* measurer = [RPSOpenMeasurer new];
    [measurer setMeasureTarget:self];
    return measurer;
}

@end
