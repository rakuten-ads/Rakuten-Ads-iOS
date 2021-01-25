//
//  RUNAAdSessionInner.h
//  Banner
//
//  Created by Wu, Wei | David on 2021/01/13.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#ifndef RUNAAdSessionInner_h
#define RUNAAdSessionInner_h

#import "RUNAAdSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNAAdSession()

@property (nonatomic, readonly) NSString* uuid;
@property (atomic, readonly, nullable) NSMutableArray<NSNumber*>* blockAdList;

-(void) addBlockAd:(NSInteger) advId;

@end

NS_ASSUME_NONNULL_END

#endif /* RUNAAdSessionInner_h */
