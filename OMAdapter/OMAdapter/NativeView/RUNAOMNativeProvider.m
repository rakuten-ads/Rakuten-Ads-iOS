//
//  RUNAViewabilityNativeProvider.m
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/01/25.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import "RUNAOMNativeProvider.h"
#import "RUNAOMNativeMeasurer.h"
#import "RUNAOMMeasurableTarget.h"
#import <RUNACore/RUNAUIView+.h>
#import <RUNACore/RUNAValid.h>

@implementation RUNAOMNativeProviderConfiguration

NSString* omVerificationJsURL = @"https://storage.googleapis.com/rssp-dev-cdn/sdk/js/omid-validation-verification-script-v1-1.4.3.js";
NSString* omJsURL = @"https://storage.googleapis.com/rssp-dev-cdn/sdk/js/omsdk-v1-1.4.3.js";
NSString* vendorKey = @"iabtechlab.com-omid";
NSString* params = @"iabtechlab-Rakuten";

+(instancetype)defaultConfiguration {
    RUNAOMNativeProviderConfiguration* config = [RUNAOMNativeProviderConfiguration new];
    config.verificationJsURL = omVerificationJsURL;
    config.providerURL = omJsURL;
    config.vendorKey = vendorKey;
    config.vendorParameters = params;
    return config;
}

@end

@interface RUNAOMNativeProvider()

@property(nonatomic) NSMutableDictionary<NSString*, RUNAOMMeasurableTarget*>* targetDict;

@end

@implementation RUNAOMNativeProvider

-(instancetype)initWithConfiguration:(RUNAOMNativeProviderConfiguration *)configuration {
    self = [super init];
    if (self) {
        self->_configuration = configuration;
        self.targetDict = [NSMutableDictionary new];
    }
    return self;
}

- (void)registerTargetView:(nonnull UIView *)view {
    if (!view) {
        NSLog(@"[RUNA] OMSDK Target view must not be nil");
        return;
    }
    if (!self.configuration) {
        NSLog(@"[RUNA] RUNAOMNativeProviderConfiguration must not be nil");
        return;
    }
    if ([RUNAValid isEmptyString:self.configuration.verificationJsURL]) {
        NSLog(@"[RUNA] RUNAOMNativeProviderConfiguration verificationJsURL mustn't be empty");
        return;
    }
    if ([RUNAValid isEmptyString:self.configuration.vendorKey]) {
        NSLog(@"[RUNA] RUNAOMNativeProviderConfiguration vendorKey mustn't be empty");
        return;
    }
    if ([RUNAValid isEmptyString:self.configuration.vendorParameters]) {
        NSLog(@"[RUNA] RUNAOMNativeProviderConfiguration vendorParameters mustn't be empty");
        return;
    }

    if ([RUNAValid isEmptyString:self.configuration.providerURL]) {
        NSLog(@"[RUNA] RUNAOMNativeProviderConfiguration providerURL not found, use default provider");
        self.configuration.providerURL = omJsURL;
    }

    RUNAOMNativeMeasurer* measurer = [RUNAOMNativeMeasurer new];
    measurer.configuration = self.configuration;

    RUNAOMMeasurableTarget* target = [[RUNAOMMeasurableTarget alloc] initWithView:view];
    [self.targetDict setObject:target forKey:target.identifier];
    target.measurer = measurer;
    [target.measurer startMeasurement];
}

- (void)unregisterTargetView:(UIView *)view {
    NSString* identifier = view.runaViewIdentifier;
    [self.targetDict[identifier].measurer finishMeasurement];
    [self.targetDict removeObjectForKey: identifier];
}

@end
