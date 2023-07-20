//
//  RUNAViewabilityProvider.m
//  Banner
//
//  Created by Wu, Wei | David on 2021/05/26.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNAViewabilityProvider.h"
#import <RUNACore/RUNAURLString.h>
#import <RUNACore/RUNAUIView+.h>

@interface RUNAViewabilityProvider()

@property(nonatomic) NSMutableDictionary<NSString*, RUNAMeasurableTarget*>* targetDict;

@end

@implementation RUNAViewabilityProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.targetDict = [NSMutableDictionary new];
    }
    return self;
}

-(void)registerTarget:(RUNAMeasurableTarget *)target {
    if (!target) {
        NSLog(@"[RUNA] Target must not be nil");
        return;
    }

    [target.measurers.allValues enumerateObjectsUsingBlock:^(id<RUNAMeasurer>  _Nonnull measurer, NSUInteger idx, BOOL * _Nonnull stop) {
        [measurer startMeasurement];
    }];

    [self.targetDict setObject:target forKey:target.identifier];
}

-(void)unregisterTarget:(RUNAMeasurableTarget *)target {
    if (!target) {
        NSLog(@"[RUNA] Target must not be nil");
        return;
    }

    [target.measurers.allValues enumerateObjectsUsingBlock:^(id<RUNAMeasurer>  _Nonnull measurer, NSUInteger idx, BOOL * _Nonnull stop) {
        [measurer finishMeasurement];
    }];

    [self.targetDict removeObjectForKey:target.identifier];
}

-(void)registerTargetView:(UIView *)view withViewImpURL:(nullable NSString *)url completionHandler:(nullable RUNAViewabilityCompletionHandler)handler {
    if (!view) {
        NSLog(@"[RUNA] Target view must not be nil");
        return;
    }

    RUNAMeasurableTarget* target = [[RUNAMeasurableTarget alloc] initWithView:view];
    RUNAMeasurementConfiguration* config = [RUNAMeasurementConfiguration new];
    config.viewImpURL = url;
    config.completionHandler = handler;
    [target setRUNAMeasurementConfiguration:config];
    [target.measurers.allValues.firstObject startMeasurement];

    [self.targetDict setObject:target forKey:target.identifier];
}

-(void)unregsiterTargetView:(UIView *)view {
    [self unregisterTargetView:view];
}

-(void)unregisterTargetView:(UIView *)view {
    if (!view) {
        NSLog(@"[RUNA] Target view must not be nil");
        return;
    }
    [self unregisterTarget:self.targetDict[view.runaViewIdentifier]];
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
