//
//  RUNARemoteLogEntity.m
//  Core
//
//  Created by Wu, Wei | David on 2020/12/03.
//  Copyright © 2020 Rakuten MPD. All rights reserved.
//

#import "RUNARemoteLogEntity.h"

@implementation RUNARemoteLogEntityErrorDetail

-(NSDictionary *)toDictionary {
    NSMutableDictionary* dict = [NSMutableDictionary new];
    if (self.errorMessage) {
        [dict setValue:self.errorMessage forKey:@"error_message"];
    }
    if (self.stacktrace && self.stacktrace.count > 0) {
        [dict setValue:[self.stacktrace componentsJoinedByString:@"\n"] forKey:@"stacktrace"];
    }
    if (self.tag) {
        [dict setValue:self.tag forKey:@"tag"];
    }
    if (self.ext && self.ext.count > 0) {
        [dict setObject:self.ext forKey:@"ext"];
    }
    return dict;
}

-(id)copyWithZone:(NSZone *)zone {
    RUNARemoteLogEntityErrorDetail* newObj = [[RUNARemoteLogEntityErrorDetail allocWithZone:zone] init];
    newObj.errorMessage = self.errorMessage;
    newObj.ext = self.ext;
    newObj.stacktrace = self.stacktrace;
    newObj.tag = self.tag;
    return newObj;
}

@end

@implementation RUNARemoteLogEntityUser

-(NSDictionary *)toDictionary {
    NSMutableDictionary* dict = [NSMutableDictionary new];
    if (self.id) {
        [dict setValue:self.id forKey:@"id"];
    }

    if (self.ext && self.ext.count > 0) {
        [dict setObject:self.ext forKey:@"ext"];
    }
    return dict;
}

-(id)copyWithZone:(NSZone *)zone {
    RUNARemoteLogEntityUser* newObj = [[RUNARemoteLogEntityUser allocWithZone:zone] init];
    newObj.id = self.id;
    newObj.ext = self.ext;
    return newObj;
}

@end

@implementation RUNARemoteLogEntityAd

int kSDKTypeIOS = 1; // 1=iOS/2=Android/3=JS

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_timestamp = [NSDate new];
        self->_sdkType = kSDKTypeIOS;
    }
    return self;
}

-(NSDictionary *)toDictionary {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];

    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:@{
        @"date" : [formatter stringFromDate:self.timestamp] ?: NSNull.null,
        @"sdk_type" : @(self.sdkType),
        @"sdk_version" : self.sdkVersion ?: NSNull.null,
    }];
    if (self.adspotId) {
        [dict setValue:self.adspotId forKey:@"adspot_id"];
    }

    if (self.batchAdspotList && self.batchAdspotList.count > 0) {
        [dict setObject:self.batchAdspotList forKey:@"sr_adspot_ids"];
    }

    if (self.sessionId) {
        [dict setValue:self.sessionId forKey:@"session_id"];
    }
    
    return dict;
}

-(id)copyWithZone:(NSZone *)zone {
    RUNARemoteLogEntityAd* newObj = [[RUNARemoteLogEntityAd allocWithZone:zone] init];
    newObj.adspotId = self.adspotId;
    newObj.batchAdspotList = self.batchAdspotList;
    newObj.sessionId = self.sessionId;
    newObj.sdkVersion = self.sdkVersion;
    newObj->_timestamp = [self.timestamp copy];
    newObj->_sdkType = self.sdkType;
    return newObj;
}

@end



@implementation RUNARemoteLogEntity

+ (instancetype)logWithError:(RUNARemoteLogEntityErrorDetail *)errorDetail andUserInfo:(RUNARemoteLogEntityUser *)userInfo adInfo:(RUNARemoteLogEntityAd *)adInfo {
    RUNARemoteLogEntity* instance = [RUNARemoteLogEntity new];
    instance.errorDetail = errorDetail;
    instance.userInfo = userInfo;
    instance.adInfo = adInfo;
    return instance;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"error: %@, user: %@, ad: %@",
            self.errorDetail.toDictionary, self.userInfo.toDictionary, self.adInfo.toDictionary];
}

-(id)copyWithZone:(NSZone *)zone {
    RUNARemoteLogEntity* newObj = [[RUNARemoteLogEntity allocWithZone:zone] init];
    newObj.errorDetail = self.errorDetail;
    newObj.adInfo = self.adInfo;
    newObj.userInfo = self.userInfo;
    return newObj;
}

@end
