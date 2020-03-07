//
//  RPSOpenMeasurementAdapter.m
//  OMAdapter
//
//  Created by Wu, Wei b on R 2/03/05.
//  Copyright © Reiwa 2 RPS. All rights reserved.
//

#import "RPSOpenMeasurer.h"
#import <OMSDK_Rakuten/OMIDSDK.h>
#import <OMSDK_Rakuten/OMIDAdSession.h>
#import <OMSDK_Rakuten/OMIDAdSessionContext.h>
#import <OMSDK_Rakuten/OMIDAdSessionConfiguration.h>

#import "RPSBannerViewInner.h"
#import "RPSDefines.h"

@interface RPSOpenMeasurer() <RPSMeasurer>

@property(nonatomic, weak, nullable) UIView* adView;

-(OMIDRakutenAdSession*) createAdSession;
-(OMIDRakutenAdSessionContext*) createAdSessionContext;
-(OMIDRakutenAdSessionConfiguration*) createAdSessionConfiguration;

@end

NSString* kPartnerName = @"RPSRDN";

@implementation RPSOpenMeasurer

-(void)startMeasurement {
    if (![self isSDKActive]
        || !self.adView) {
        RPSLog("Not prepared for measurement.");
        return;
    }
    
    OMIDRakutenAdSession* adSession = [self createAdSession];
}

- (void)finishMeasurement {
    
}

- (void)setMeasureTarget:(nonnull id<RPSOpenMeasurement>)target {
    if ([target isKindOfClass:UIView.class]) {
        self.adView = (UIView*) target;
    } else {
        RPSLog("target must be kind of UIView class");
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
    NSString* partnerVersion = [RPSDefines sharedInstance].sdkBundleShortVersionString;
    OMIDRakutenPartner* partener = [[OMIDRakutenPartner alloc] initWithName:kPartnerName versionString:partnerVersion];
    if (partener) {
        OMIDRakutenAdSessionContext* context = [self createAdSessionContextWithPartner: partener];
        OMIDRakutenAdSessionConfiguration* config = [self createAdSessionConfiguration];
        NSError* error;
        session = [[OMIDRakutenAdSession alloc] initWithConfiguration:config adSessionContext:context error:&error];
        if (error) {
            RPSDebug("Can not create OMIDRakutenAdSession: %@", error);
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
