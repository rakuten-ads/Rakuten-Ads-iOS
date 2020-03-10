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

#import "RUNABannerViewInner.h"
#import "RUNADefines.h"

@interface RUNAOpenMeasurer() <RUNAMeasurer>

@property(nonatomic, weak, nullable) UIView* adView;

-(OMIDRakutenAdSession*) createAdSession;
-(OMIDRakutenAdSessionContext*) createAdSessionContext;
-(OMIDRakutenAdSessionConfiguration*) createAdSessionConfiguration;

@end

NSString* kPartnerName = @"RUNA";

@implementation RUNAOpenMeasurer

-(void)startMeasurement {
    if (![self isSDKActive]
        || !self.adView) {
        RUNALog("Not prepared for measurement.");
        return;
    }
    
    OMIDRakutenAdSession* adSession = [self createAdSession];
}

- (void)finishMeasurement {
    
}

- (void)setMeasureTarget:(nonnull id<RUNAOpenMeasurement>)target {
    if ([target isKindOfClass:UIView.class]) {
        self.adView = (UIView*) target;
    } else {
        RUNALog("target must be kind of UIView class");
    }
}


-(BOOL) isSDKActive {
    if (!OMIDRakutenSDK.sharedInstance.isActive) {
        [OMIDRakutenSDK.sharedInstance activate];
    }
    return OMIDRakutenSDK.sharedInstance.isActive;
}


-(OMIDRakutenAdSession *)createAdSession {
    OMIDRakutenAdSession* session = nil;
    NSString* partnerVersion = [RUNADefines sharedInstance].sdkBundleShortVersionString;
    OMIDRakutenPartner* partener = [[OMIDRakutenPartner alloc] initWithName:kPartnerName versionString:partnerVersion];
    if (partener) {
        OMIDRakutenAdSessionContext* context = [self createAdSessionContextWithPartner: partener];
        OMIDRakutenAdSessionConfiguration* config = [self createAdSessionConfiguration];
        NSError* error;
        session = [[OMIDRakutenAdSession alloc] initWithConfiguration:config adSessionContext:context error:&error];
        if (error) {
            RUNADebug("Can not create OMIDRakutenAdSession: %@", error);
        } else {
            session.mainAdView = self.adView;
        }
    }
    return session;
}

-(OMIDRakutenAdSessionContext *)createAdSessionContextWithPartner:(OMIDRakutenPartner*) partner {
    return nil;
}

-(OMIDRakutenAdSessionConfiguration *)createAdSessionConfiguration {
    return nil;
}

@end
