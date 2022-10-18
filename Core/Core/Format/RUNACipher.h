//
//  RUNACipher.h
//  Core
//
//  Created by Wu, Wei | David | GATD on 2022/10/14.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUNACore/RUNACore-Swift.h>
//#import "RUNACore-Swift.h"
//@class RUNACryptoWrapper;

NS_ASSUME_NONNULL_BEGIN

@interface RUNACipher : NSObject

+(nullable NSString*) md5:(NSString*) text;

@end

NS_ASSUME_NONNULL_END
