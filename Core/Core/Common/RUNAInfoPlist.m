//
//  RUNADictionary.m
//  Core
//
//  Created by Wu, Wei | David on 2020/11/20.
//  Copyright © 2020 Rakuten MPD. All rights reserved.
//

#import "RUNAInfoPlist.h"


NSString* RUNA_INFO_KEY_HOST_URL = @"RUNA_HOST_URL";
NSString* RUNA_INFO_KEY_BASE_URL_JS = @"RUNA_BASE_URL_JS";
NSString* RUNA_INFO_KEY_REMOTE_LOG_HOST_URL = @"RUNA_INFO_KEY_REMOTE_LOG_HOST_URL";
NSString* RUNA_INFO_KEY_REMOTE_LOG_DISABLED = @"RUNA_INFO_KEY_REMOTE_LOG_DISABLED";

@implementation RUNAInfoPlist

+(nullable instancetype) sharedInstance {
    static RUNAInfoPlist* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [RUNAInfoPlist new];
        [instance loadFromBundle:NSBundle.mainBundle];
    });
    return instance;
}

- (void) loadFromBundle: (NSBundle*) bundle {
    NSString* runaInfoFilePath = [bundle pathForResource:@"runa" ofType:@"plist"];
    NSDictionary* runaInfo = [NSDictionary dictionaryWithContentsOfFile:runaInfoFilePath];
    if (runaInfo) {
        RUNADebug("load runa.plist %@", runaInfo);
        self->_hostURL = [runaInfo valueForKey:RUNA_INFO_KEY_HOST_URL];
        self->_baseURLJs = [runaInfo valueForKey:RUNA_INFO_KEY_BASE_URL_JS];
        self->_remoteLogDisabled = [[runaInfo valueForKey:RUNA_INFO_KEY_REMOTE_LOG_DISABLED] boolValue];
        self->_remoteLogHostURL = [runaInfo valueForKey:RUNA_INFO_KEY_REMOTE_LOG_HOST_URL];
    }
}

@end
