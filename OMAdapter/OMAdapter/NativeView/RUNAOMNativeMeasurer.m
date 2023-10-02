//
//  RUNANativeOpenMeasurer.m
//  OMAdapter
//
//  Created by Wu, Wei | David | GATD on 2023/01/25.
//  Copyright © 2023 RUNA. All rights reserved.
//

#import "RUNAOMNativeMeasurer.h"
#import "RUNAOpenMeasurer.h"
#import "RUNAOpenMeasurerProvider.h"

#import <OMSDK_Rakuten/OMIDSDK.h>
#import <OMSDK_Rakuten/OMIDAdSession.h>
#import <OMSDK_Rakuten/OMIDAdSessionContext.h>
#import <OMSDK_Rakuten/OMIDAdSessionConfiguration.h>
#import <OMSDK_Rakuten/OMIDAdEvents.h>
#import <OMSDK_Rakuten/OMIDVerificationScriptResource.h>

#import <RUNACore/RUNADefines.h>
#import <RUNACore/RUNARemoteLogger.h>

@interface RUNAOMNativeMeasurer()

@property(nonatomic, weak, nullable) UIView* adView;
@property(nonatomic, nonnull) OMIDRakutenAdSession* adSession;

@end

@implementation RUNAOMNativeMeasurer

- (void)startMeasurement {
    RUNADebug("measurement[OM][native] start");
    if (![self isSDKActive]
        || !self.adView) {
        RUNALog("[RUNA] Not prepared for open measurement[OM][native].");
        return;
    }

    [self createAdSession];
    if (self.adSession) {
        NSError* err;
        OMIDRakutenAdEvents* event = [[OMIDRakutenAdEvents alloc] initWithAdSession:self.adSession error:&err];
        if (err) {
            RUNADebug("measurement[OM][native] create OMIDRakutenAdEvents failed: %@", err);
            [self sendRemoteLogWithMessage:@"measurement[OM][native] create OMIDRakutenAdEvents failed:" andError:err];
            return;
        }

        RUNADebug("measurement[OM][native] start");
        [self.adSession start];

        err = nil;
        [event loadedWithError:&err];
        if (err) {
            RUNADebug("measurement[OM][native] unable to trigger loaded OM event: %@)", err);
            [self sendRemoteLogWithMessage:@"measurement[OM][native] unable to trigger loaded OM event:" andError:err];
            return;
        }

        err = nil;
        [event impressionOccurredWithError:&err];
        if (err) {
            RUNADebug("measurement[OM][native] OMID impression failed: %@", err);
            [self sendRemoteLogWithMessage:@"measurement[OM][native] OMID impression failed:" andError:err];
            return;
        }
    } else {
        RUNADebug("measurement[OM][native] OMID session not ready");
    }
}

- (void)finishMeasurement {
    RUNADebug("measurement[OM][native] finish");
    [self.adSession finish];
}

- (void)setMeasureTarget:(nonnull id<RUNAOpenMeasurement>)target {
    self.adView = target.getOMAdView;
}

- (void)setMeasurerDelegate:(nonnull id<RUNAMeasurerDelegate>)measurerDelegate {

}

-(BOOL) isSDKActive {
    if (!OMIDRakutenSDK.sharedInstance.isActive) {
        [OMIDRakutenSDK.sharedInstance activate];
    }

    RUNADebug("measurement[OM][native] OMIDRakutenSDK %@ is Actived: %@", OMIDRakutenSDK.versionString, OMIDRakutenSDK.sharedInstance.isActive ? @"YES" : @"NO");
    return OMIDRakutenSDK.sharedInstance.isActive;
}

-(void)createAdSession {
    NSString* partnerVersion = [RUNADefines sharedInstance].sdkBundleShortVersionString;
    OMIDRakutenPartner* partener = [[OMIDRakutenPartner alloc] initWithName:kPartnerName versionString:partnerVersion];
    if (partener) {
        OMIDRakutenAdSessionContext* context = [self createAdSessionContextWithPartner: partener];
        OMIDRakutenAdSessionConfiguration* config = [self createAdSessionConfiguration];
        if (context && config) {
            NSError* error;
            self.adSession = [[OMIDRakutenAdSession alloc] initWithConfiguration:config adSessionContext:context error:&error];
            if (error) {
                RUNADebug("measurement[OM][native] create OMIDRakutenAdSession failed: %@", error);
                [self sendRemoteLogWithMessage:@"measurement[OM][native] create OMIDRakutenAdSession failed:" andError:error];
            } else {
                RUNADebug("measurement[OM][native] created OMIDRakutenAdSession");
                self.adSession.mainAdView = self.adView;
            }
        } else {
            RUNADebug("measurement[OM][native] created OMIDRakutenAdSession failed: context or config not ready");
        }
    }
}



-(OMIDRakutenAdSessionContext *)createAdSessionContextWithPartner:(OMIDRakutenPartner*) partner {
    OMIDRakutenAdSessionContext* context = nil;

    RUNADebug("measurement[OM][native] create OMIDRakutenAdSessionContext");

    OMIDRakutenVerificationScriptResource* resourceVerifyJs = [[OMIDRakutenVerificationScriptResource alloc] initWithURL:[NSURL URLWithString:self.configuration.verificationJsURL] vendorKey: self.configuration.vendorKey parameters:self.configuration.vendorParameters];
    if (!resourceVerifyJs) {
        RUNADebug("measurement[OM][native] create OMIDRakutenVerificationScriptResource failed, the configuration parameters must not contain nil");
        return nil;
    }

    NSMutableArray *resources = [NSMutableArray new];
    [resources addObject:resourceVerifyJs];

    NSString* omSdkJs = [self omidJSScript];
    if (omSdkJs) {
        NSError* err;
        context = [[OMIDRakutenAdSessionContext alloc] initWithPartner:partner script:omSdkJs resources:resources contentUrl:nil customReferenceIdentifier:nil error:&err];
        if (err) {
            RUNADebug("measurement[OM][native] create OMIDRakutenAdSessionContext failed: %@", err);
            [self sendRemoteLogWithMessage:@"measurement[OM][native] create OMIDRakutenAdSessionContext failed:" andError:err];
        }
    }

    return context;
}

-(OMIDRakutenAdSessionConfiguration *)createAdSessionConfiguration {
    OMIDRakutenAdSessionConfiguration* config = nil;
    NSError* err;
    config = [[OMIDRakutenAdSessionConfiguration alloc]
              initWithCreativeType:OMIDCreativeTypeNativeDisplay
              impressionType:OMIDImpressionTypeViewable
              impressionOwner:OMIDNativeOwner
              mediaEventsOwner:OMIDNoneOwner
              isolateVerificationScripts:YES
              error:&err];
    RUNADebug("measurement[OM][native] create OMIDRakutenAdSessionConfiguration");
    if (err) {
        RUNADebug("measurement[OM][native] create OMIDRakutenAdSessionConfiguration failed: %@", err);
        [self sendRemoteLogWithMessage:@"measurement[OM][native] create OMIDRakutenAdSessionConfiguration failed:" andError:err];
    }
    return config;
}

-(nullable NSString*) omidJSScript {
    RUNAOpenMeasurerProvider* provider = [[RUNAOpenMeasurerProvider alloc] initWithURL:self.configuration.providerURL];
    NSError* err;
    NSString* omidJSScript = [provider.cacheFile readStringWithError:&err];
    if (err) {
        RUNADebug("measurement[OM][native] Destination of omProviderURL not found");
    }
    return omidJSScript;
}

-(void) sendRemoteLogWithMessage:(NSString*) message andError:(nullable NSError*) error {
    NSException* exception = [NSException exceptionWithName:error.description reason:@"RUNA OMSDK" userInfo:nil];

    RUNARemoteLogEntityErrorDetail* errorDetail = [RUNARemoteLogEntityErrorDetail new];
    errorDetail.errorMessage = [message stringByAppendingFormat:@": [%@] %@ { userInfo: %@ }", exception.name, exception.reason, exception.userInfo];
    errorDetail.stacktrace = exception.callStackSymbols;
    errorDetail.tag = @"RUNAOMAdapter";

    // ad info
    RUNARemoteLogEntityAd* adInfo = [RUNARemoteLogEntityAd new];
    adInfo.sdkVersion = [RUNAOpenMeasurer versionString];

    RUNARemoteLogEntity* log = [RUNARemoteLogEntity logWithError:errorDetail andUserInfo:nil adInfo:adInfo];
    [RUNARemoteLogger.sharedInstance sendLog:log];
}
@end
