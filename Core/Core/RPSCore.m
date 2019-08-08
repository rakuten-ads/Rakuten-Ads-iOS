//
//  RPSCore.m
//  Core
//
//  Created by Wu, Wei b on 2019/07/03.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSCore.h"

@implementation RPSCore

+(NSString *)sdkBundleVersionShortString {
    return [[[NSBundle bundleForClass:RPSCore.class] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
