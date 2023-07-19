//
//  RUNAOMNativeTarget.m
//  OMAdapter
//
//  Created by Wu, Wei | David | GATD on 2023/06/02.
//  Copyright © 2023 RUNA. All rights reserved.
//

#import "RUNAOMMeasurableTarget.h"
#import "RUNAOMNativeMeasurer.h"
#import <RUNACore/RUNAUIView+.h>

@interface RUNAOMMeasurableTarget()

@end

@implementation RUNAOMMeasurableTarget

-(instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        self->_view = view;
        self->_identifier = view.runaViewIdentifier;
    }
    return self;
}

-(void)setMeasurer:(id<RUNAMeasurer>)measurer {
    self->_measurer = measurer;
    [measurer setMeasureTarget:self];
}

-(id<RUNAMeasurer>)getOpenMeasurer {
    return self.measurer;
}

-(UIView *)getOMAdView {
    return self.view;
}

-(WKWebView *)getOMWebView {
    return nil;
}

-(NSString *)injectOMProvider:(NSString *)omProviderURL IntoHTML:(NSString *)html {
    return html;
}

@end
