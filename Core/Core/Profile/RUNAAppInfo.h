//
//  RUNAAppInfo.h
//  Core
//
//  Created by Wu, Wei b on 2019/02/15.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAAppInfo : NSObject

@property(nonatomic, readonly) NSString* bundleIdentifier;
@property(nonatomic, readonly, nullable) NSString* bundleVersion;
@property(nonatomic, readonly, nullable) NSString* bundleShortVersion;
@property(nonatomic, readonly, nullable) NSString* bundleName;

@end

NS_ASSUME_NONNULL_END
