//
//  RPSNativeAds.m
//  RDN
//
//  Created by Wu, Wei b on 2019/03/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSNativeAdsInner.h"
#import "RPSBidAdapter.h"
#import "RPSDefines.h"
#import <RPSCore/RPSValid.h>
#import "RPSNativeAdsAdapter.h"

typedef BOOL (^RPSNativeAdsEventHandler)(RPSNativeAdsLoader* loader, NSArray<RPSNativeAds*>* adsList);

@interface RPSNativeAdsLoader()<RPSBidResponseConsumer>

@property (nonatomic, copy) RPSNativeAdsEventHandler handler;

@end

@implementation RPSNativeAdsLoader

-(void)loadWithCompletionHandler:(BOOL (^)(RPSNativeAdsLoader * _Nonnull, NSArray<RPSNativeAds*> * _Nonnull))handler {
    self.handler = handler;

    dispatch_async(RPSDefines.sharedQueue, ^{
        @try {
            VERBOSE_LOG(@"%@", RPSDefines.sharedInstance);
            if ([RPSValid isEmptyString:self.adSpotId]) {
                NSLog(@"[RPS] require adSpotId!");
                @throw [NSException exceptionWithName:@"init failed" reason:@"adSpotId is empty" userInfo:nil];
            }

            RPSNativeAdsAdapter* adapter = [RPSNativeAdsAdapter new];
            adapter.adspotId = self.adSpotId;
            adapter.responseConsumer = self;

            RPSOpenRTBRequest* request = [RPSOpenRTBRequest new];
            request.openRTBAdapterDelegate = adapter;

            [request resume];
        } @catch(NSException* exception) {
            VERBOSE_LOG(@"load exception: %@", exception);
            [self triggerFailure];
        }
    });
    
}

- (void) triggerFailure{

}

- (void)onBidResponseFailed {
    VERBOSE_LOG(@"native ads spot id %@ load failed", self.adSpotId);
     [self triggerFailure];
}

- (void)onBidResponseSuccess:(nonnull NSArray<RPSNativeAds*> *)adInfoList {
    if (self.handler) {
        self.handler(self, adInfoList);
    }
}

/**
 * implement RPSBidResponseConsumer's method
 */
- (nonnull RPSNativeAds*)parse:(nonnull NSDictionary *)bid {
    return [RPSNativeAds parse:bid];
}

@end
