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
@property(nonatomic, readonly) id<RUNAMeasurer> measurer;

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
    if (!self->_measurer) {
        self->_measurer = [RUNADefaultMeasurer new];
        [self->_measurer setMeasureTarget:self];
        [self->_measurer setMeasurerDelegate:self];
    }
    return self->_measurer;
}

-(BOOL)measureImp {
    RUNADebug("measurement[default] skip measure imp");
    return YES;
}

-(BOOL)measureInview {
    RUNADebug("measurement[default] measure inview rate: %f", self.visibility);
    return self.visibility > 0.5;
}

- (BOOL)sendMeasureViewImp {
    if (self.viewImpURL) {
        RUNADebug("measurement[default] send inview %p", self);
        RUNAURLStringRequest* request = [RUNAURLStringRequest new];
        request.httpTaskDelegate = self.viewImpURL;
        [request resume];
    }
    return YES;
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

-(BOOL)didMeasureInview:(BOOL)isInview {
    if (isInview) {
        [self sendMeasureViewImp];
        if (self.completionHandler) {
            self.completionHandler(self.view);
        }
        return YES;
    }
    return NO;
}

@end

@interface RUNAViewabilityProvider()

@property(nonatomic) NSMutableDictionary<NSString*, RUNAViewabilityTarget*>* targetDict;

@end

@implementation RUNAViewabilityProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.targetDict = [NSMutableDictionary dictionary];
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
    [self.targetDict setObject:target forKey:target.identifier];
    [[target getDefaultMeasurer] startMeasurement];
}

-(void)unregsiterTargetView:(UIView *)view {
    NSString* identifier = [NSString stringWithFormat:@"%lu", (unsigned long)view.hash];
    [self.targetDict[identifier].measurer finishMeasurement];
    [self.targetDict removeObjectForKey: identifier];
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
