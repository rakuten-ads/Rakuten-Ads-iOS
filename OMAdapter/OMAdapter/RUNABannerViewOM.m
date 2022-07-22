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
    RUNADebug("SDK RUNA/OMAdapter version: %@", [RUNAOpenMeasurer versionString]);
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
    error.ext = self.descriptionDetail;
    
    // user info
    self.logUserInfo = nil;
    
    // ad info
    self.logAdInfo.adspotId = self.adSpotId;
    self.logAdInfo.sessionId = self.sessionId;
    self.logAdInfo.sdkVersion = [RUNAOpenMeasurer versionString];
    
    RUNARemoteLogEntity* log = [RUNARemoteLogEntity logWithError:error andUserInfo:self.logUserInfo adInfo:self.logAdInfo];
    [RUNARemoteLogger.sharedInstance sendLog:log];
}

@end
