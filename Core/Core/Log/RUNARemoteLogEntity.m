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
    if (self.stacktrace) {
        [dict setValue:self.stacktrace forKey:@"stacktrace"];
    }
    if (self.tag) {
        [dict setValue:self.tag forKey:@"tag"];
    }
    if (self.ext) {
        [dict setObject:self.ext forKey:@"ext"];
    }
    return dict;
}

@end

@implementation RUNARemoteLogEntityUser

-(NSDictionary *)toDictionary {
    NSMutableDictionary* dict = [NSMutableDictionary new];
    if (self.id) {
        [dict setValue:self.id forKey:@"id"];
    }

    if (self.ext) {
        [dict setObject:self.ext forKey:@"ext"];
    }
    return dict;
}

@end

@implementation RUNARemoteLogEntityAd

-(NSDictionary *)toDictionary {
    NSMutableDictionary* dict = [NSMutableDictionary new];
    if (self.adspotId) {
        [dict setValue:self.adspotId forKey:@"adspot_id"];
    }

    if (self.batchAdspotList) {
        [dict setObject:self.batchAdspotList forKey:@"sr_adspot_ids"];
    }

    if (self.sessionId) {
        [dict setValue:self.sessionId forKey:@"session_id"];
    }
    return dict;
}

@end



@implementation RUNARemoteLogEntity

+(instancetype)logWithError:(RUNARemoteLogEntityErrorDetail *)errorDetail andUserInfo:(RUNARemoteLogEntityUser *)userInfo adInfo:(RUNARemoteLogEntityAd *)adInfo {
    RUNARemoteLogEntity* instance = [RUNARemoteLogEntity new];
    instance.errorDetail = errorDetail;
    instance.userInfo = userInfo;
    instance.adInfo = adInfo;
    return instance;
}

@end
