//
//  RUNAAppInfo.m
//  Core
//
//  Created by Wu, Wei b on 2019/02/15.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNAAppInfo.h"

@implementation RUNAAppInfo

@synthesize bundleIdentifier = _bundleIdentifier;
@synthesize bundleVersion = _bundleVersion;
@synthesize bundleShortVersion = _bundleShortVersion;
@synthesize bundleName = _bundleName;

-(NSString *)bundleIdentifier {
    if (!self->_bundleIdentifier) {
        return NSBundle.mainBundle.bundleIdentifier;
    }
    return self->_bundleIdentifier;
}


-(NSString *)bundleVersion {
    if (!self->_bundleVersion) {
        return NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"];
    }
    return self->_bundleVersion;
}

-(NSString *)bundleShortVersion {
    if (!self->_bundleShortVersion) {
        return NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
    }
    return self->_bundleShortVersion;
}

-(NSString *)bundleName {
    if (!self->_bundleName) {
        return NSBundle.mainBundle.infoDictionary[@"CFBundleName"];
    }
    return self->_bundleName;
}

-(NSString *)description {
    return [NSString stringWithFormat:
            @"bundle ID: %@\n"
            @"bundle version: %@\n"
            @"bundle short version: %@\n"
            @"bundle name: %@\n"
            ,
            self.bundleIdentifier,
            self.bundleVersion,
            self.bundleShortVersion,
            self.bundleName,
            nil];
}

@end
