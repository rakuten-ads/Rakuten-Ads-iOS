//
//  RUNAViewabilityNativeProvider.h
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/25.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <RUNABanner/RUNAViewabilityProvider.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAOMNativeProviderConfiguration : NSObject

@property(nonatomic, nullable) NSString* verificationJsURL;
@property(nonatomic, nullable) NSString* providerURL;
@property(nonatomic, nullable) NSString* vendorKey;
@property(nonatomic, nullable) NSString* vendorParameters;

+(instancetype) defaultConfiguration;

@end

@interface RUNAOMNativeProvider : NSObject

-(instancetype) init NS_UNAVAILABLE;
+(instancetype) new NS_UNAVAILABLE;

@property(nonatomic, readonly) RUNAOMNativeProviderConfiguration* configuration;

-(instancetype) initWithConfiguration:(RUNAOMNativeProviderConfiguration*) configuration;

-(void) registerTargetView:(UIView*) view;

-(void) unregisterTargetView:(UIView*) view;

@end

NS_ASSUME_NONNULL_END
