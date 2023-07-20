//
//  RUNAMeasurableTarget.m
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/07/20.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import "RUNAMeasurableTarget.h"
#import <RUNABanner/RUNABanner.h>
#import <RUNACore/RUNAURLString.h>
#import <RUNACore/RUNAUIView+.h>

@implementation RUNAMeasurementConfiguration

@end

@interface RUNAMeasurableTarget()

@property(nonatomic, nullable) RUNAMeasurementConfiguration* defaultMeasurementConfig;

@end

@implementation RUNAMeasurableTarget

NSString* kRUNAMeasurerDefault = @"RUNADefaultMeasurer";

- (instancetype)initWithView:(UIView*) view
{
    self = [super init];
    if (self) {
        self.view = view;
        self->_identifier = view.runaViewIdentifier;
        self->_measurers = [NSMutableDictionary new];
    }
    return self;
}

-(void)setRUNAMeasurementConfiguration:(RUNAMeasurementConfiguration *)config {
    self.defaultMeasurementConfig = config;

    RUNADefaultMeasurer* measurer = [RUNADefaultMeasurer new];
    [measurer setMeasurerDelegate:self];
    [measurer setMeasureTarget:self];
    self.measurers[kRUNAMeasurerDefault] = measurer;
}

# pragma mark - Protocal RUNADefaultMeasurement
-(id<RUNAMeasurer>) getDefaultMeasurer {
    return self.measurers[kRUNAMeasurerDefault];
}

-(BOOL)measureImp {
    RUNADebug("measurement[Viewable] skip measure imp");
    return YES;
}

-(BOOL)measureInview {
    UIViewController *rootVc = [[[UIApplication sharedApplication].windows firstObject]rootViewController];
    if(rootVc) {
        float visibility = [self getVisibility:self.view.window rootViewController:rootVc];
        RUNADebug("measurement[Viewable] measure inview rate: %f", visibility);
        return [self isVisible:visibility];
    } else {
        return NO;
    }
}

- (void) sendMeasureViewImp {
    if (self.defaultMeasurementConfig.viewImpURL) {
        RUNADebug("measurement[Viewable] send inview %p", self);
        RUNAURLStringRequest* request = [RUNAURLStringRequest new];
        request.httpTaskDelegate = self.defaultMeasurementConfig.viewImpURL;
        [request resume];
    }
}

-(float)getVisibility:(UIWindow *)window
   rootViewController:(UIViewController *)rootViewController {
    float areaOfAdView = self.view.frame.size.width * self.view.frame.size.height;
    UIView* rootView = rootViewController.view;
    CGRect abstractFrame = [self.view convertRect:self.view.bounds toView:rootView];
    CGRect intersectionFrame = CGRectIntersection(rootView.frame, abstractFrame);

    RUNADebug("measurement[Viewable] get abstractFrame %@ of self %@ in root %@", NSStringFromCGRect(abstractFrame), NSStringFromCGRect(self.view.frame), NSStringFromCGRect(rootView.frame));
    if (!self.view.isHidden
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

# pragma mark - Protocol RUNAMeasurerDelegate
-(BOOL)didMeasureInview:(BOOL)isInview {
    if (isInview) {
        [self sendMeasureViewImp];
        if (self.defaultMeasurementConfig.completionHandler) {
            @try {
                self.defaultMeasurementConfig.completionHandler(self.view);
            } @catch (NSException *exception) {
                RUNALog("exception when measure completion callback: %@", exception);
            }
        }
    }
    return isInview;
}

@end
