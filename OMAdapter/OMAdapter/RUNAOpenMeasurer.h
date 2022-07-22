//
//  RUNAOpenMeasurementAdapter.h
//  OMAdapter
//
//  Created by Wu, Wei b on R 2/03/05.
//  Copyright © Reiwa 2 RUNA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUNAMeasurement.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNAOpenMeasurer : NSObject<RUNAMeasurer>

+(NSString*) versionString;

@end

NS_ASSUME_NONNULL_END
