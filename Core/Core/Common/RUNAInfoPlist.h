//
//  RUNADictionary.h
//  Core
//
//  Created by Wu, Wei | David on 2020/11/20.
//  Copyright © 2020 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAInfoPlist : NSObject

@property(nullable, readonly) NSString* hostURL;
@property(nullable, readonly) NSString* baseURLJs;

@property(nullable, readonly) NSString* remoteLogHostURL;
@property(readonly) BOOL remoteLogDisabled;

+(nullable instancetype) sharedInstance;

@end

NS_ASSUME_NONNULL_END
