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
        NSString* runaInfoFilePath = [[NSBundle mainBundle] pathForResource:@"runa" ofType:@"plist"];
        NSDictionary* runaInfo = [NSDictionary dictionaryWithContentsOfFile:runaInfoFilePath];
        if (runaInfo) {
            RUNADebug("load runa.plist %@", runaInfo);
            instance = [RUNAInfoPlist new];
            instance->_hostURL = [runaInfo valueForKey:RUNA_INFO_KEY_HOST_URL];
            instance->_baseURLJs = [runaInfo valueForKey:RUNA_INFO_KEY_BASE_URL_JS];
            instance->_remoteLogDisabled = [[runaInfo valueForKey:RUNA_INFO_KEY_REMOTE_LOG_DISABLED] boolValue];
            instance->_remoteLogHostURL = [runaInfo valueForKey:RUNA_INFO_KEY_REMOTE_LOG_HOST_URL];
        }
    });
    return instance;
}

@end
