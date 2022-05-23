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
        self->_bundleIdentifier = [NSBundle.mainBundle.bundleIdentifier copy];
    }
    return self->_bundleIdentifier;
}


-(NSString *)bundleVersion {
    if (!self->_bundleVersion) {
        self->_bundleVersion = [NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"] copy];
    }
    return self->_bundleVersion;
}

-(NSString *)bundleShortVersion {
    if (!self->_bundleShortVersion) {
        self->_bundleShortVersion = [NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] copy];
    }
    return self->_bundleShortVersion;
}

-(NSString *)bundleName {
    if (!self->_bundleName) {
        self->_bundleName = [NSBundle.mainBundle.infoDictionary[@"CFBundleName"] copy];
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
