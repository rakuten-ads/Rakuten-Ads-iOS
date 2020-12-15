//
//  RUNABannerViewOM.m
//  OMAdapter
//
//  Created by Wu, Wei b on R 2/03/06.
//  Copyright © Reiwa 2 RUNA. All rights reserved.
//

#import "RUNABannerViewOMInner.h"
#import "RUNABannerViewInner.h"
#import "RUNAOpenMeasurer.h"
#import "RUNAOpenMeasurerProvider.h"
#import <OMSDK_Rakuten/OMIDScriptInjector.h>

@implementation RUNABannerView(OMSDK)

-(void)disableOpenMeasurement {
    self.openMeasurementDisabled = true;
}

-(id<RUNAMeasurer>) getOpenMeasurer {
    RUNADebug("SDK RUNA/OMAdapter version: %@", self.om_versionString);
    RUNAOpenMeasurer* measurer = [RUNAOpenMeasurer new];
    [measurer setMeasureTarget:self];
    return measurer;
}

-(UIView *)getOMAdView {
    return self;
}

-(WKWebView *)getOMWebView {
    return self.webView;
}

-(NSString*) injectOMProvider:(NSString*) omProviderURL IntoHTML:(NSString*) html {
    RUNAOpenMeasurerProvider* provider = [[RUNAOpenMeasurerProvider alloc] initWithURL:omProviderURL];
    NSError* err;
    NSString* omidJSScript = [provider.cacheFile readStringWithError:&err];
    if (omidJSScript) {
        NSString* creativeWithOMID = [OMIDRakutenScriptInjector injectScriptContent:omidJSScript intoHTML:html error:&err];
        if (creativeWithOMID) {
            return creativeWithOMID;
        }
    }
    RUNADebug("inject js script: %@", err ?: @"success");
    return html;
}

-(void) om_sendRemoteLogWithMessage:(NSString*) message andException:(NSException*) exception {
    RUNARemoteLogEntityErrorDetail* error = [RUNARemoteLogEntityErrorDetail new];
    error.errorMessage = [message stringByAppendingFormat:@": [%@] %@ { userInfo: %@ }", exception.name, exception.reason, exception.userInfo];
    error.stacktrace = exception.callStackSymbols;
    error.tag = @"RUNAOMAdapter";
    error.ext = @{
        @"state" : self.descpritionState,
        @"postion" : @(self.position),
        @"size" : @(self.size),
        @"properties" : self.properties ?: NSNull.null,
        @"om_disabled" : self.openMeasurementDisabled ? @"YES" : @"NO",
        @"om_available" : self.isOpenMeasurementAvailable ? @"YES" : @"NO",
        @"iframe_enabled" : self.iframeWebContentEnabled ? @"YES" : @"NO",
    };
    
    // user info
    self.logUserInfo = nil;
    
    // ad info
    self.logAdInfo.adspotId = self.adSpotId;
    self.logAdInfo.sessionId = self.sessionId;
    self.logAdInfo.sdkVersion = self.om_versionString;
    
    RUNARemoteLogEntity* log = [RUNARemoteLogEntity logWithError:error andUserInfo:self.logUserInfo adInfo:self.logAdInfo];
    [RUNARemoteLogger.sharedInstance sendLog:log];
}

-(NSString*) om_versionString {
    return [[[NSBundle bundleForClass:RUNAOpenMeasurer.class] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
