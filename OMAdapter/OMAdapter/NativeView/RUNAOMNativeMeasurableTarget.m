//
//  RUNAOMNativeTarget.m
//  OMAdapter
//
//  Created by Wu, Wei | David | GATD on 2023/06/02.
//  Copyright © 2023 RUNA. All rights reserved.
//

#import "RUNAOMNativeMeasurableTarget.h"
#import "RUNAOMNativeMeasurer.h"
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

@implementation RUNAMeasurableTarget(OMSDK)

NSString* kRUNAMeasurerOM = @"RUNAOMNativeMeasurer";
-(void)setRUNAOMNativeConfiguration:(RUNAOMNativeProviderConfiguration *)config {
    if (!self.view) {
        NSLog(@"[RUNA] OMSDK Target view must not be nil");
        return;
    }
    if (!config) {
        NSLog(@"[RUNA] RUNAOMNativeProviderConfiguration must not be nil");
        return;
    }
    if ([RUNAValid isEmptyString:config.verificationJsURL]) {
        NSLog(@"[RUNA] RUNAOMNativeProviderConfiguration verificationJsURL mustn't be empty");
        return;
    }
    if ([RUNAValid isEmptyString:config.vendorKey]) {
        NSLog(@"[RUNA] RUNAOMNativeProviderConfiguration vendorKey mustn't be empty");
        return;
    }
    if ([RUNAValid isEmptyString:config.vendorParameters]) {
        NSLog(@"[RUNA] RUNAOMNativeProviderConfiguration vendorParameters mustn't be empty");
        return;
    }

    if ([RUNAValid isEmptyString:config.providerURL]) {
        NSLog(@"[RUNA] RUNAOMNativeProviderConfiguration providerURL not found, use default provider");
        config.providerURL = omJsURL;
    }

    RUNAOMNativeMeasurer* measurer = [RUNAOMNativeMeasurer new];
    measurer.configuration = config;
    [measurer setMeasureTarget:self];
    self.measurers[kRUNAMeasurerOM] = measurer;
}

#pragma mark - Protocol RUNAOpenMeasurement

-(UIView *)getOMAdView {
    return self.view;
}

- (nullable WKWebView *)getOMWebView {
    return nil;
}

- (nonnull id<RUNAMeasurer>)getOpenMeasurer {
    return self.measurers[kRUNAMeasurerOM];
}

- (nonnull NSString *)injectOMProvider:(nonnull NSString *)omProviderURL IntoHTML:(nonnull NSString *)html {
    return html;
}

@end
