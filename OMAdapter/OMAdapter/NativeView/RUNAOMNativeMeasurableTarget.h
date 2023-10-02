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

/*!
 Configuration for OM (open measurement) on native adviews
 */
@interface RUNAOMNativeProviderConfiguration : NSObject

/// URL of verification JS resource
@property(nonatomic, nullable) NSString* verificationJsURL;

/// URL of OMSDK JS resource
@property(nonatomic, nullable) NSString* providerURL;

/// value of vendor key
@property(nonatomic, nullable) NSString* vendorKey;

/// value of vendor parameters, split by comma
@property(nonatomic, nullable) NSString* vendorParameters;

/*!
 Get a default configuration of vendor RUNA
 */
+(instancetype) defaultConfiguration;

@end

/*!
 A target object supported by OM (open measurement)
 */
@interface RUNAMeasurableTarget(OMSDK) <RUNAOpenMeasurement>

/*!
 Set configuration of OM on native adviews to enable.
 @Param config configuration of OM on native adviews
 */
-(void)setRUNAOMNativeConfiguration:(RUNAOMNativeProviderConfiguration *)config;

@end

NS_ASSUME_NONNULL_END
