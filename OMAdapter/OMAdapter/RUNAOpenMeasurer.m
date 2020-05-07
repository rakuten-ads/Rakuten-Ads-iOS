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

#import "RUNABannerViewInner.h"
#import "RUNADefines.h"

@interface RUNAOpenMeasurer()

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
        RUNALog("Not prepared for open measurement.");
        return;
    }
    
    [self createAdSession];
    if (self.adSession) {
        NSError* err;
        OMIDRakutenAdEvents* event = [[OMIDRakutenAdEvents alloc] initWithAdSession:self.adSession error:&err];
        if (err) {
            RUNADebug("create OMIDRakutenAdEvents failed: %@", err);
            return;
        }
        
        RUNADebug("Starting open measurement session");
        [self.adSession start];
        
        err = nil;
        [event loadedWithError:&err];
        if (err) {
            RUNADebug("Unable to trigger loaded OM event: %@)", err);
            return;
        }
        
        err = nil;
        [event impressionOccurredWithError:&err];
        if (err) {
            RUNADebug("OMID impression failed: %@", err);
            return;
        }
    }
}

- (void)finishMeasurement {
    RUNADebug("Finishing open measurement session");
    [self.adSession finish];
}

-(BOOL) isSDKActive {
    if (!OMIDRakutenSDK.sharedInstance.isActive) {
        [OMIDRakutenSDK.sharedInstance activate];
    }
    RUNADebug("OMIDRakutenSDK is Actived: %@", OMIDRakutenSDK.sharedInstance.isActive ? @"YES" : @"NO");
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
    }
    return config;
}

#pragma mark - RUNAOpenMeasurement

- (void)setMeasureTarget:(nonnull id<RUNAOpenMeasurement>)target {
    self.adView = [target getOMAdView];
    if (!self.adView) {
        RUNALog("OM target AdView must not be nil");
    }
    self.webView = [target getOMWebView];
    if (!self.adView) {
        RUNADebug("OM target WebView is nil");
    }
}

@end
