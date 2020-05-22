//
//  RUNANativeAdProvider.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/03/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//
#import "RUNANativeAdInner.h"
#import "RUNANativeAdAdapter.h"
#import <RUNACore/RUNAValid.h>
#import <RUNACore/RUNADefines.h>

typedef void (^RUNANativeAdEventHandler)(RUNANativeAdProvider* loader, NSArray<RUNANativeAd*>* adsList);

@interface RUNANativeAdProvider()<RUNABidResponseConsumerDelegate>

@property (nonatomic, copy) RUNANativeAdEventHandler handler;

@end

@implementation RUNANativeAdProvider

- (instancetype)initWithAdSpotId:(NSString *)adSpotId
{
    self = [super init];
    if (self) {
        self.adSpotId = adSpotId;
    }
    return self;
}

-(void)loadWithCompletionHandler:(void (^)(RUNANativeAdProvider * _Nonnull, NSArray<RUNANativeAd*> * _Nonnull))handler {
    self.handler = handler;

    dispatch_async(RUNADefines.sharedQueue, ^{
        @try {
            RUNALog("%@", RUNADefines.sharedInstance);
            if ([RUNAValid isEmptyString:self.adSpotId]) {
                NSLog(@"[RUNA] require adSpotId!");
                @throw [NSException exceptionWithName:@"init failed" reason:@"adSpotId is empty" userInfo:nil];
            }

            RUNANativeAdAdapter* adapter = [RUNANativeAdAdapter new];
            adapter.adspotId = self.adSpotId;
            adapter.responseConsumer = self;

            RUNAOpenRTBRequest* request = [RUNAOpenRTBRequest new];
            request.openRTBAdapterDelegate = adapter;

            [request resume];
        } @catch(NSException* exception) {
            RUNALog("load exception: %@", exception);
            [self triggerFailure];
        }
    });
    
}

- (void) triggerFailure{
    if (self.handler) {
        self.handler(self, @[]);
    }
}

- (void)onBidResponseFailed {
    RUNALog("native ads spot id %@ load failed", self.adSpotId);
     [self triggerFailure];
}

- (void)onBidResponseSuccess:(nonnull NSArray<RUNANativeAd*> *)adInfoList {
    if (self.handler) {
        self.handler(self, adInfoList);
    }
}

#pragma mark - RUNABidResponseConsumer protocol implementation
- (nonnull RUNANativeAd*)parse:(nonnull NSDictionary *)bid {
    return [RUNANativeAd parse:bid];
}

@end
