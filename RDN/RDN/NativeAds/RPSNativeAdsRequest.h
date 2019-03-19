//
//  RPSNativeAds.h
//  RDN
//
//  Created by Wu, Wei b on 2019/03/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RPSNativeAdsAssetImage : NSObject

@property(nonatomic, readonly) NSString* url;
@property(nonatomic, readonly) int w;
@property(nonatomic, readonly) int h;

@end


@interface RPSNativeAdsAsset : NSObject

@property(nonatomic, readonly, getter=isRequired) Boolean required;
@property(nonatomic, readonly, nullable) NSString* title;
@property(nonatomic, readonly, nullable) RPSNativeAdsAssetImage* img;
@property(nonatomic, readonly, nullable) NSString* data;
@property(nonatomic, readonly, nullable) NSString* link;

@end

@interface RPSNativeAdsEventTracker : NSObject

@property(nonatomic, readonly) int method;
@property(nonatomic, readonly) NSString* url;

@end

@interface RPSNativeAds : NSObject

@property(nonatomic, readonly, nullable) NSArray<RPSNativeAdsAsset*>* assets;
@property(nonatomic, readonly, nullable) NSArray<NSString*>* eventTrackers;
@property(nonatomic, readonly, nullable) NSString* link;

@end

@interface RPSNativeRequest: NSObject

-(void) loadWithCompletionHandler:(nullable BOOL (^)(RPSNativeRequest* req, RPSNativeAds* ads)) handler;

@end

NS_ASSUME_NONNULL_END
