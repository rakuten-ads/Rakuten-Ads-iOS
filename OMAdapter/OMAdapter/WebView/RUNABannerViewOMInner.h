//
//  RUNABannerViewOMInner.h
//  OMAdapter
//
//  Created by Wu, Wei b on R 2/07/17.
//  Copyright © Reiwa 2 RUNA. All rights reserved.
//

#ifndef RUNABannerViewOMInner_h
#define RUNABannerViewOMInner_h

#import "RUNABannerViewInner.h"
#import "RUNAMeasurement.h"

@interface RUNABannerView(OMSDK)<RUNAOpenMeasurement>

-(void) om_sendRemoteLogWithMessage:(NSString*) message andException:(NSException*) exception;

@end

#endif /* RUNABannerViewOMInner_h */
