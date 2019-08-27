//
//  RPSNativeAdProvider.m
//  RDN
//
//  Created by Wu, Wei b on 2019/03/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//
#import "RPSNativeAdInner.h"
#import "RPSDefines.h"
#import "RPSNativeAdAdapter.h"
#import <RPSCore/RPSValid.h>

typedef void (^RPSNativeAdEventHandler)(RPSNativeAdProvider* loader, NSArray<RPSNativeAd*>* adsList);

@interface RPSNativeAdProvider()<RPSBidResponseConsumerDelegate>

@property (nonatomic, copy) RPSNativeAdEventHandler handler;

@end

@implementation RPSNativeAdProvider

- (instancetype)initWithAdSpotId:(NSString *)adSpotId
{
    self = [super init];
    if (self) {
        self.adSpotId = adSpotId;
    }
    return self;
}

-(void)loadWithCompletionHandler:(void (^)(RPSNativeAdProvider * _Nonnull, NSArray<RPSNativeAd*> * _Nonnull))handler {
    self.handler = handler;

    dispatch_async(RPSDefines.sharedQueue, ^{
        @try {
            RPSLog("%@", RPSDefines.sharedInstance);
            if ([RPSValid isEmptyString:self.adSpotId]) {
                NSLog(@"[RPS] require adSpotId!");
                @throw [NSException exceptionWithName:@"init failed" reason:@"adSpotId is empty" userInfo:nil];
            }

            RPSNativeAdAdapter* adapter = [RPSNativeAdAdapter new];
            adapter.adspotId = self.adSpotId;
            adapter.responseConsumer = self;

            RPSOpenRTBRequest* request = [RPSOpenRTBRequest new];
            request.openRTBAdapterDelegate = adapter;

            [request resume];
        } @catch(NSException* exception) {
            RPSLog("load exception: %@", exception);
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
    RPSLog("native ads spot id %@ load failed", self.adSpotId);
     [self triggerFailure];
}

- (void)onBidResponseSuccess:(nonnull NSArray<RPSNativeAd*> *)adInfoList {
    if (self.handler) {
        self.handler(self, adInfoList);
    }
}

#pragma mark - RPSBidResponseConsumer protocol implementation
- (nonnull RPSNativeAd*)parse:(nonnull NSDictionary *)bid {
    return [RPSNativeAd parse:bid];
}

@end
