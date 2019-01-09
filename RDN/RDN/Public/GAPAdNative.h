//
//  GAPAdNative.h
//  RsspSDK
//
//  Created by Wu Wei on 2018/07/30.
//  Copyright © 2018 LOB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GAPAdNative : NSObject

-(void) requestWithAdSpotId:(nonnull NSString*) adSpotId completionHandler:(nonnull void (^)(NSDictionary<NSString*, NSObject*>* _Nullable adInfo))handler;

@end
