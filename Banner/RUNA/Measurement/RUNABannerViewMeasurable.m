//
//  RUNABannerViewMeasurable.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/09/02.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUNAMeasurement.h"
#import "RUNABannerViewInner.h"
#import <RUNACore/RUNAURLString.h>

@interface RUNABannerView(RUNAMeasurement)<RUNADefaultMeasurement>

@end

@implementation RUNABannerView(RUNAMeasurement)

-(id<RUNAMeasurer>)getDefaultMeasurer {
    RUNADefaultMeasurer* measurer = [RUNADefaultMeasurer new];
    [measurer setMeasureTarget:self];
    return measurer;
}

-(BOOL)measureInview {
    if (!self.banner.inviewURL) {
        RUNADebug("measurement[default] measure stopped by empty measure inview URL");
        return YES;
    }
    RUNADebug("measurement[default] measure inview rate: %f", self.visibility);
    if (self.visibility > 0.5) {
        RUNADebug("measurement[default] send inview %p", self);
        RUNAURLStringRequest* request = [RUNAURLStringRequest new];
        request.httpTaskDelegate = self.banner.inviewURL;
        [request resume];
        return YES;
    }
    return NO;
}

-(BOOL)measureImp {
    if (!self.banner.measuredURL) {
        RUNADebug("measurement[default] measure stopped by empty measure imp URL");
        return YES;
    }

    RUNADebug("measurement[default] measure imp (%p)", self);
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
