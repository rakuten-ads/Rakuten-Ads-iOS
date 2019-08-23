//
//  RPSDevice.m
//  RsspSDK
//
//  Created by Wu Wei on 2018/08/06.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RPSDevice.h"
#import <sys/sysctl.h>

@implementation RPSDevice

@synthesize osVersion = _osVersion;
@synthesize model = _model;
@synthesize buildName = _buildName;
@synthesize language = _language;

-(NSString*)osVersion {
    if (!self->_osVersion) {
        self->_osVersion = UIDevice.currentDevice.systemVersion;
    }
    return self->_osVersion;
}

-(NSString *)model {
    if (!self->_model) {
        self->_model = [self getModel];
    }
    return self->_model;
}

-(NSString *)buildName {
    if (!self->_buildName) {
        self->_buildName = [self getBuildName];
    }
    return self->_buildName;
}

-(NSString *)language {
    if (!self->_language) {
        self->_language = [NSLocale.currentLocale objectForKey:NSLocaleLanguageCode];
    }
    return self->_language;
}

-(NSString*) getModel {
    size_t bufferSize;
    int status = sysctlbyname("hw.machine", NULL, &bufferSize, NULL, 0);
    if (status != 0) {
        return nil;
    }
    
    NSMutableData *buffer = [[NSMutableData alloc] initWithLength:bufferSize];
    status = sysctlbyname("hw.machine", buffer.mutableBytes, &bufferSize, NULL, 0);
    if (status != 0) {
        return nil;
    }
    return [[NSString alloc] initWithCString:buffer.mutableBytes encoding:NSUTF8StringEncoding];
}

-(NSString*) getBuildName {
    size_t bufferSize;
    int status = sysctlbyname("kern.osversion", NULL, &bufferSize, NULL, 0);
    if (status != 0) {
        return nil;
    }
    
    NSMutableData *buffer = [[NSMutableData alloc] initWithLength:bufferSize];
    status = sysctlbyname("kern.osversion", buffer.mutableBytes, &bufferSize, NULL, 0);
    if (status != 0) {
        return nil;
    }
    return [[NSString alloc] initWithCString:buffer.mutableBytes encoding:NSUTF8StringEncoding];
}

-(NSString *)description {
    return [NSString stringWithFormat:
            @"OS version: %@\n"
            @"model: %@\n"
            @"build name: %@\n"
            @"language: %@\n"
            ,
            self.osVersion,
            self.model,
            self.buildName,
            self.language,
            nil];
}

@end
