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

@property(nonatomic) NSString* verificationJsURL;
@property(nonatomic) NSString* providerURL;
@property(nonatomic) NSString* vendorKey;
@property(nonatomic) NSString* vendorParameters;

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
