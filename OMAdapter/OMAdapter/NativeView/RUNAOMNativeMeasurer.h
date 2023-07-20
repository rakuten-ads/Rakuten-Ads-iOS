//
//  RUNANativeOpenMeasurer.h
//  OMAdapter
//
//  Created by Wu, Wei | David | GATD on 2023/01/25.
//  Copyright © 2023 RUNA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUNABanner/RUNAMeasurement.h>
#import <RUNAOMAdapter/RUNAOMMeasurableTarget.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAOMNativeMeasurer : NSObject<RUNAMeasurer>

@property(nonatomic) RUNAOMNativeProviderConfiguration* configuration;

@end

NS_ASSUME_NONNULL_END
