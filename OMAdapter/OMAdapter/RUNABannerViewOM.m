//
//  RUNABannerViewOM.m
//  OMAdapter
//
//  Created by Wu, Wei b on R 2/03/06.
//  Copyright © Reiwa 2 RUNA. All rights reserved.
//

#import "RUNABannerViewInner.h"
#import "RUNAOpenMeasurer.h"
#import <OMSDK_Rakuten/OMIDScriptInjector.h>

@interface RUNABannerView(OMSDK)<RUNAOpenMeasurement>

@end

@implementation RUNABannerView(OMSDK)

-(id<RUNAMeasurer>) getOpenMeasurer {
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

-(NSString*) injectOMIDIntoHTML:(NSString*) html {
    NSURL* omidJSServiceUrl =  [[NSBundle bundleForClass:RUNAOpenMeasurer.class] URLForResource:@"omsdk-v1" withExtension:@"js"];
    NSError* err;
    NSString* omidJSService = [NSString stringWithContentsOfURL:omidJSServiceUrl encoding:NSUTF8StringEncoding error:&err];
    if (omidJSService) {
        NSString* creativeWithOMID = [OMIDRakutenScriptInjector injectScriptContent:omidJSService intoHTML:html error:&err];
        if (err) {
            RUNADebug("Unable to inject OMID JS into ad creative: %@", err);
        } else {
            return creativeWithOMID;
        }
    }
    return html;
}

@end
