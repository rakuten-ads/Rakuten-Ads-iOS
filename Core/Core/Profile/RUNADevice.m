//
//  RUNADevice.m
//  RsspSDK
//
//  Created by Wu Wei on 2018/08/06.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RUNADevice.h"
#import <sys/sysctl.h>
#import <Network/Network.h>

@implementation RUNADevice {
    nw_path_monitor_t monitor;
}

@synthesize osVersion = _osVersion;
@synthesize model = _model;
@synthesize buildName = _buildName;
@synthesize language = _language;
@synthesize connectionMethod = _connectionMethod;

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

-(void) startNetworkMonitor {
    self->_connectionMethod = RUNA_DEVICE_CONN_METHOD_UNKNOWN;
    if (@available(iOS 12, *)) {
        RUNADebug("startNetworkMonitor");
        monitor = nw_path_monitor_create();
        __weak RUNADevice* weakSelf = self;
        nw_path_monitor_set_update_handler(monitor, ^(nw_path_t  _Nonnull path) {
            if (weakSelf) {
                __strong RUNADevice* strongSelf = weakSelf;
                BOOL isWiFi = nw_path_uses_interface_type(path, nw_interface_type_wifi);
                BOOL isCellular = nw_path_uses_interface_type(path, nw_interface_type_cellular);
                BOOL isEthernet = nw_path_uses_interface_type(path, nw_interface_type_wired);
                RUNA_DEVICE_CONN_METHOD method = (isEthernet ? RUNA_DEVICE_CONN_METHOD_ETHERNET :
                                                  isWiFi ? RUNA_DEVICE_CONN_METHOD_WIFI :
                                                  isCellular ? RUNA_DEVICE_CONN_METHOD_CELLULAR :
                                                  RUNA_DEVICE_CONN_METHOD_UNKNOWN);
                RUNADebug("network path monitor updated to %d", (int)method);
                strongSelf->_connectionMethod = method;
            }
        });
        nw_path_monitor_start(monitor);
    }
}

-(void) cancelNetworkMonitor {
    if (@available(iOS 12, *)) {
        if (monitor) {
            RUNADebug("cancelNetworkMonitor");
            nw_path_monitor_cancel(monitor);
        }
    }
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
