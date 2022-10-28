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
    measurer.isVideoTrack = (self.mediaType == RUNA_MEDIA_TYPE_VIDEO);
    return measurer;
}

# pragma mark - measure imp
-(BOOL)measureImp {
    if (!self.banner.measuredURL) {
        RUNADebug("measurement[default] measure stopped by empty measure imp URL");
    }
    return YES;
}

# pragma mark - measure inview
-(BOOL)measureInview {
    if (!self.banner.inviewURL) {
        RUNADebug("measurement[default] measure stopped by empty measure inview URL");
        return YES;
    }
    UIViewController *rootVc = [[[UIApplication sharedApplication]keyWindow]rootViewController];
    float visibility = [self getVisibility:self.window rootViewController:rootVc];
    RUNADebug("measurement[default] measure inview rate: %f", visibility);
    return [self isVisible:visibility];
}

-(float)getVisibility:(UIWindow *)window
   rootViewController:(UIViewController *)rootViewController {
    float areaOfAdView = self.frame.size.width * self.frame.size.height;
    UIView* rootView = rootViewController.view;
    CGRect abstractFrame = [self convertRect:self.bounds toView:rootView];
    CGRect intersectionFrame = CGRectIntersection(rootView.frame, abstractFrame);

    RUNADebug("get abstractFrame %@ of self %@ in root %@", NSStringFromCGRect(abstractFrame), NSStringFromCGRect(self.frame), NSStringFromCGRect(rootView.frame));
    if (!self.isHidden
        && window
        && areaOfAdView > 0
        && !CGRectIsNull(intersectionFrame)) {
        float areaOfIntersection = intersectionFrame.size.width * intersectionFrame.size.height;
        return areaOfIntersection / areaOfAdView;
    }
    return 0;
}

-(BOOL)isVisible:(float)visibility {
    return visibility > 0.5;
}

@end
