//
//  RUNANativeOpenMeasurer.m
//  OMAdapter
//
//  Created by Wu, Wei | David | GATD on 2023/01/25.
//  Copyright © 2023 RUNA. All rights reserved.
//

#import "RUNANativeOpenMeasurer.h"
#import "RUNAOpenMeasurer.h"
#import "RUNAOpenMeasurerProvider.h"

#import <OMSDK_Rakuten/OMIDSDK.h>
#import <OMSDK_Rakuten/OMIDAdSession.h>
#import <OMSDK_Rakuten/OMIDAdSessionContext.h>
#import <OMSDK_Rakuten/OMIDAdSessionConfiguration.h>
#import <OMSDK_Rakuten/OMIDAdEvents.h>
#import <OMSDK_Rakuten/OMIDVerificationScriptResource.h>

#import <RUNACore/RUNADefines.h>

@interface RUNANativeOpenMeasurer()

@property(nonatomic, weak, nullable) id<RUNAMeasurer> target;

@property(nonatomic, weak, nullable) UIView* adView;
@property(nonatomic, nonnull) OMIDRakutenAdSession* adSession;

@end

@implementation RUNANativeOpenMeasurer

- (void)startMeasurement {

}

- (void)finishMeasurement {
    RUNADebug("measurement[OM] finish");
    [self.adSession finish];
}

- (void)setMeasureTarget:(nonnull id<RUNAMeasurable>)target {

}

- (void)setMeasurerDelegate:(nonnull id<RUNAMeasurerDelegate>)measurerDelegate {

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

NSString* omVerificationJsURL = @"";
NSString* vendorKey = @"iabtechlab.com-omid";
NSString* params = @"iabtechlab-Rakuten";

-(OMIDRakutenAdSessionContext *)createAdSessionContextWithPartner:(OMIDRakutenPartner*) partner {
    OMIDRakutenAdSessionContext* context = nil;
    NSMutableArray *scripts = [NSMutableArray new];
    [scripts addObject:[[OMIDRakutenVerificationScriptResource alloc] initWithURL:[NSURL URLWithString:omVerificationJsURL] vendorKey: vendorKey
                                                                parameters:params]];

    NSError* err;
    context = [[OMIDRakutenAdSessionContext alloc] initWithPartner:partner script:@"js" resources:scripts contentUrl:nil customReferenceIdentifier:nil error:&err];
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

NSString* omProviderURL = @"";
-(nullable NSString*) omidJSScript {
    RUNAOpenMeasurerProvider* provider = [[RUNAOpenMeasurerProvider alloc] initWithURL:omProviderURL];
    NSError* err;
    NSString* omidJSScript = [provider.cacheFile readStringWithError:&err];
    if (err) {
        RUNADebug("Destination of omProviderURL not found");
    }
    return omidJSScript;
}

-(void) sendRemoteLogWithMessage:(NSString*) message andError:(NSError*) error {
//    if ([self.measurableTarget isKindOfClass:[RUNABannerView class]]) {
//        NSException* exception = [NSException exceptionWithName:error.description reason:@"RUNA OMSDK" userInfo:nil];
//        [(RUNABannerView*)self.measurableTarget om_sendRemoteLogWithMessage:message andException:exception];
//    }
}
@end
