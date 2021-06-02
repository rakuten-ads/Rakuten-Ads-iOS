//
//  RUNAViewabilityProvider.m
//  Banner
//
//  Created by Wu, Wei | David on 2021/05/26.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNAViewabilityProvider.h"
#import "RUNAMeasurement.h"
#import <RUNACore/RUNAURLString.h>

@interface RUNAViewabilityTarget : NSObject<RUNADefaultMeasurement, RUNAMeasurerDelegate>

@property(nonatomic, readonly) NSString* identifier;
@property(nonatomic, weak) UIView* view;
@property(nonatomic, copy, nullable) NSString* viewImpURL;
@property(nonatomic, copy, nullable) RUNAViewabilityCompletionHandler completionHandler;

@end

@implementation RUNAViewabilityTarget

- (instancetype)initWithView:(UIView*) view
{
    self = [super init];
    if (self) {
        self.view = view;
        self->_identifier = [NSString stringWithFormat:@"%lu", (unsigned long)view.hash];
    }
    return self;
}

-(id<RUNAMeasurer>) getDefaultMeasurer {
    RUNADefaultMeasurer* measurer = [RUNADefaultMeasurer new];
    [measurer setMeasureTarget:self];
    [measurer setMeasurerDelegate:self];
    return measurer;
}

-(BOOL)measureImp {
    return true;
}

-(BOOL)measureInview {
    RUNADebug("measurement[default] measure inview rate: %f", self.visibility);
    return self.visibility > 0.5;
}

- (BOOL)sendMeasureImp {
    if (self.viewImpURL) {
        RUNADebug("measurement[default] send inview %p", self);
        RUNAURLStringRequest* request = [RUNAURLStringRequest new];
        request.httpTaskDelegate = self.viewImpURL;
        [request resume];
    }
    return true;
}


-(float)visibility {
    float areaOfAdView = self.view.frame.size.width * self.view.frame.size.height;
    UIView* rootView = UIApplication.sharedApplication.keyWindow.rootViewController.view;
    CGRect abstractFrame = [self.view convertRect:self.view.bounds toView:rootView];
    CGRect intersectionFrame = CGRectIntersection(rootView.frame, abstractFrame);

    RUNADebug("get abstractFrame %@ of self %@ in root %@", NSStringFromCGRect(abstractFrame), NSStringFromCGRect(self.view.frame), NSStringFromCGRect(rootView.frame));
    if (!self.view.isHidden
        && self.view.window
        && areaOfAdView > 0
        && !CGRectIsNull(intersectionFrame)) {
        float areaOfIntersection = intersectionFrame.size.width * intersectionFrame.size.height;
        return areaOfIntersection / areaOfAdView;
    }
    return 0;
}

- (void)didMeasurementInView:(BOOL)isMeasuredInview {
    if (self.completionHandler
        && isMeasuredInview) {
        self.completionHandler(self.view);
    }
}

@end

@interface RUNAViewabilityProvider()

@property(nonatomic) NSMutableDictionary<NSString*, RUNADefaultMeasurer*>* measuerDict;

@end

@implementation RUNAViewabilityProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.measuerDict = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)registerTargetView:(UIView *)view withViewImpURL:(nullable NSString *)url completionHandler:(nullable RUNAViewabilityCompletionHandler)handler {
    if (!view) {
        NSLog(@"Target view must not be nil");
        return;
    }

    RUNAViewabilityTarget* target = [[RUNAViewabilityTarget alloc] initWithView:view];
    target.viewImpURL = url;
    target.completionHandler = handler;
    RUNADefaultMeasurer* measuer = [target getDefaultMeasurer];
    [self.measuerDict setObject:measuer forKey:target.identifier];
    [measuer startMeasurement];
}

-(void)unregsiterTargetView:(UIView *)view {
    NSString* identifier = [NSString stringWithFormat:@"%lu", (unsigned long)view.hash];
    [self.measuerDict[identifier] finishMeasurement];
    [self.measuerDict removeObjectForKey: identifier];
}

+(instancetype)sharedInstance {
    static RUNAViewabilityProvider* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [RUNAViewabilityProvider new];
        }
    });
    return instance;
}

@end
