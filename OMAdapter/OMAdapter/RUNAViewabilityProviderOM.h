//
//  RUNAViewabilityProviderOM.h
//  OMAdapter
//
//  Created by Wu, Wei | David | GATD on 2023/07/18.
//  Copyright © 2023 RUNA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUNABanner/RUNARUNAViewabilityProvider.h>
#import "RUNAOMNativeProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNAViewabilityProvider(OMSDK) : NSObject

-(void) setRUNAOMNativeProviderConfiguration:(RUNAOMNativeProviderConfiguration) config;

@end

NS_ASSUME_NONNULL_END
