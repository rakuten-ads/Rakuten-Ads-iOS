//
//  RUNACore.m
//  Core
//
//  Created by Wu, Wei b on 2019/07/03.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUNACore.h"

@implementation RUNACore

+(NSString *)sdkBundleVersionShortString {
    return [[[NSBundle bundleForClass:RUNACore.class] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
