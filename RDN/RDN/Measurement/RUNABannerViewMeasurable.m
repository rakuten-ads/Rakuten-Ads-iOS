//
//  RUNABannerViewMeasurable.m
//  RDN
//
//  Created by Wu, Wei b on 2019/09/02.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUNAMeasurement.h"
#import "RUNABannerViewInner.h"
#import "RUNAURLString.h"

@interface RUNABannerView(RUNAMeasurement)<RUNADefaultMeasurement>

@end

@implementation RUNABannerView(RUNAMeasurement)

-(id<RUNAMeasurer>)getDefaultMeasurer {
    RUNADefaultMeasurer* measurer = [RUNADefaultMeasurer new];
    [self.measurer setMeasureTarget:self];
    return measurer;
}

-(BOOL)measureInview {
    if (!self.banner.inviewURL) {
        RUNADebug("measure stopped by empty measure inview URL");
        return YES;
    }
    RUNADebug("measure inview rate: %f", self.visibility);
    if (self.visibility > 0.5) {
        RUNAURLStringRequest* request = [RUNAURLStringRequest new];
        request.httpTaskDelegate = self.banner.inviewURL;
        [request resume];
        return YES;
    }
    return NO;
}

-(BOOL)measureImp {
    if (!self.banner.measuredURL) {
        RUNADebug("measure stopped by empty measure imp URL");
        return YES;
    }

    RUNADebug("measure imp");
    RUNAURLStringRequest* request = [RUNAURLStringRequest new];
    request.httpTaskDelegate = self.banner.measuredURL;
    [request resume];
    return YES;
}

-(float)visibility {
    float areaOfAdView = self.frame.size.width * self.frame.size.height;
    UIView* rootView = UIApplication.sharedApplication.keyWindow.rootViewController.view;
    CGRect abstractFrame = [self convertRect:self.bounds toView:rootView];
    CGRect intersectionFrame = CGRectIntersection(rootView.frame, abstractFrame);

    RUNADebug("get abstractFrame %@ of self %@ in root %@", NSStringFromCGRect(abstractFrame), NSStringFromCGRect(self.frame), NSStringFromCGRect(rootView.frame));
    if (!self.isHidden
        && self.window
        && areaOfAdView > 0
        && !CGRectIsNull(intersectionFrame)) {
        float areaOfIntersection = intersectionFrame.size.width * intersectionFrame.size.height;
        return areaOfIntersection / areaOfAdView;
    }
    return 0;
}

@end
