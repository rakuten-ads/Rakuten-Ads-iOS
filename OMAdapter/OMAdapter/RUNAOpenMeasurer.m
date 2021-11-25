//
//  RUNAOpenMeasurementAdapter.m
//  OMAdapter
//
//  Created by Wu, Wei b on R 2/03/05.
//  Copyright © Reiwa 2 RUNA. All rights reserved.
//

#import "RUNAOpenMeasurer.h"
#import <OMSDK_Rakuten/OMIDSDK.h>
#import <OMSDK_Rakuten/OMIDAdSession.h>
#import <OMSDK_Rakuten/OMIDAdSessionContext.h>
#import <OMSDK_Rakuten/OMIDAdSessionConfiguration.h>
#import <OMSDK_Rakuten/OMIDAdEvents.h>

#import "RUNABannerViewOMInner.h"
#import <RUNACore/RUNADefines.h>

@interface RUNAOpenMeasurer()

@property(nonatomic, weak, nullable) id<RUNAOpenMeasurement> measurableTarget;
@property(nonatomic, weak, nullable) UIView* adView;
@property(nonatomic, weak, nullable) WKWebView* webView;
@property(nonatomic, nonnull) OMIDRakutenAdSession* adSession;

@end

NSString* kPartnerName = @"Rakuten";

@implementation RUNAOpenMeasurer

-(void)startMeasurement {
    if (![self isSDKActive]
        || !self.adView
        || !self.webView) {
        RUNALog("Not prepared for open measurement[OM].");
        return;
    }
    
    [self createAdSession];
    if (self.adSession) {
        NSError* err;
        OMIDRakutenAdEvents* event = [[OMIDRakutenAdEvents alloc] initWithAdSession:self.adSession error:&err];
        if (err) {
            RUNADebug("create OMIDRakutenAdEvents failed: %@", err);
            [self sendRemoteLogWithMessage:@"create OMIDRakutenAdEvents failed:" andError:err];
            return;
        }
        
        RUNADebug("measurement[OM] start");
        [self.adSession start];
        
        err = nil;
        [event loadedWithError:&err];
        if (err) {
            RUNADebug("unable to trigger loaded OM event: %@)", err);
            [self sendRemoteLogWithMessage:@"unable to trigger loaded OM event:" andError:err];
            return;
        }
        
        err = nil;
        [event impressionOccurredWithError:&err];
        if (err) {
            RUNADebug("OMID impression failed: %@", err);
            [self sendRemoteLogWithMessage:@"OMID impression failed:" andError:err];
            return;
        }
    }
}

- (void)finishMeasurement {
    RUNADebug("measurement[OM] finish");
    [self.adSession finish];
}

-(BOOL) isSDKActive {
    if (!OMIDRakutenSDK.sharedInstance.isActive) {
        [OMIDRakutenSDK.sharedInstance activate];
    }
    RUNADebug("OMIDRakutenSDK %@ is Actived: %@", OMIDRakutenSDK.versionString, OMIDRakutenSDK.sharedInstance.isActive ? @"YES" : @"NO");
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
                RUNADebug("create OMIDRakutenAdSession failed: %@", error);
                [self sendRemoteLogWithMessage:@"create OMIDRakutenAdSession failed:" andError:error];
            } else {
                self.adSession.mainAdView = self.adView;
            }
        }
    }
}

-(OMIDRakutenAdSessionContext *)createAdSessionContextWithPartner:(OMIDRakutenPartner*) partner {
    OMIDRakutenAdSessionContext* context = nil;
    NSError* err;
    context = [[OMIDRakutenAdSessionContext alloc] initWithPartner:partner webView:self.webView contentUrl:nil customReferenceIdentifier:nil error:&err];
    if (err) {
        RUNADebug("create OMIDRakutenAdSessionContext failed: %@", err);
        [self sendRemoteLogWithMessage:@"create OMIDRakutenAdSessionContext failed:" andError:err];
    }
    return context;
}

-(OMIDRakutenAdSessionConfiguration *)createAdSessionConfiguration {
    OMIDRakutenAdSessionConfiguration* config = nil;
    NSError* err;
    config = [[OMIDRakutenAdSessionConfiguration alloc]
              initWithCreativeType:OMIDCreativeTypeHtmlDisplay
              impressionType:OMIDImpressionTypeBeginToRender
              impressionOwner:OMIDNativeOwner
              mediaEventsOwner:OMIDNoneOwner
              isolateVerificationScripts:YES
              error:&err];
    if (err) {
        RUNADebug("create OMIDRakutenAdSessionConfiguration failed: %@", err);
        [self sendRemoteLogWithMessage:@"create OMIDRakutenAdSessionConfiguration failed:" andError:err];
    }
    return config;
}

#pragma mark - RUNAOpenMeasurement

- (void)setMeasureTarget:(id<RUNAOpenMeasurement>)target {
    self.measurableTarget = target;
    self.adView = [target getOMAdView];
    if (!self.adView) {
        RUNADebug("OM target AdView must not be nil");
    }
    self.webView = [target getOMWebView];
    if (!self.adView) {
        RUNADebug("OM target WebView is nil");
    }
}

-(void) sendRemoteLogWithMessage:(NSString*) message andError:(NSError*) error {
    if ([self.measurableTarget isKindOfClass:[RUNABannerView class]]) {
        NSException* exception = [NSException exceptionWithName:error.description reason:@"RUNA OMSDK" userInfo:nil];
        [(RUNABannerView*)self.measurableTarget om_sendRemoteLogWithMessage:message andException:exception];
    }
}

-(NSString*) versionString {
    return @OS_STRINGIFY(RUNA_SDK_VERSION);
}

@end
