//
//  RUNAOMNativeTarget.h
//  OMAdapter
//
//  Created by Wu, Wei | David | GATD on 2023/06/02.
//  Copyright © 2023 RUNA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <RUNABanner/RUNABanner.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAOMNativeProviderConfiguration : NSObject

@property(nonatomic, nullable) NSString* verificationJsURL;
@property(nonatomic, nullable) NSString* providerURL;
@property(nonatomic, nullable) NSString* vendorKey;
@property(nonatomic, nullable) NSString* vendorParameters;

+(instancetype) defaultConfiguration;

@end

@interface RUNAMeasurableTarget(OMSDK) <RUNAOpenMeasurement>

-(void)setRUNAOMConfiguration:(RUNAOMNativeProviderConfiguration *)config;

@end

NS_ASSUME_NONNULL_END
