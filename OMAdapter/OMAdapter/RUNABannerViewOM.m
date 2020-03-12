//
//  RUNABannerViewOM.m
//  OMAdapter
//
//  Created by Wu, Wei b on R 2/03/06.
//  Copyright © Reiwa 2 RUNA. All rights reserved.
//

#import "RUNABannerViewInner.h"
#import "RUNAOpenMeasurer.h"

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
@end
