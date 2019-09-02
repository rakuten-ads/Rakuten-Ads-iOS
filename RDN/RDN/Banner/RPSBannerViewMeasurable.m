//
//  RPSBannerViewMeasurable.m
//  RDN
//
//  Created by Wu, Wei b on 2019/09/02.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSBannerViewInner.h"
#import "RPSMeasurement.h"
#import "RPSURLString.h"

@interface RPSBannerView(RPSMeasurement)<RPSMeasurableDelegate>

@end

@implementation RPSBannerView(RPSMeasurement)

-(BOOL)measureInview {
    if (!self.banner.inviewURL) {
        RPSDebug("measure stopped by empty measure inview URL");
        return YES;
    }
    RPSDebug("measure inview rate: %f", self.visibility);
    if (self.visibility > 0.5) {
        RPSURLStringRequest* request = [RPSURLStringRequest new];
        request.httpTaskDelegate = self.banner.inviewURL;
        [request resume];
        return YES;
    }
    return NO;
}

-(BOOL)measureImp {
    if (!self.banner.measuredURL) {
        RPSDebug("measure stopped by empty measure imp URL");
        return YES;
    }

    RPSDebug("measure imp");
    RPSURLStringRequest* request = [RPSURLStringRequest new];
    request.httpTaskDelegate = self.banner.measuredURL;
    [request resume];
    return YES;
}

-(float)visibility {
    float areaOfAdView = self.frame.size.width * self.frame.size.height;
    UIView* rootView = UIApplication.sharedApplication.keyWindow.rootViewController.view;
    CGRect abstractFrame = [self convertRect:self.frame toView:rootView];
    CGRect intersectionFrame = CGRectIntersection(rootView.frame, abstractFrame);
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
