//
//  RPSOpenRTB.m
//  RDN
//
//  Created by Wu, Wei b on 2019/02/26.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSOpenRTB.h"
#import <RPSCore/RPSJSONObject.h>
#import "RPSDefines.h"

@implementation RPSOpenRTBRequest

#pragma mark - HTTPSession Protocol

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_httpSession = RPSDefines.sharedInstance.httpSession;
        self.shouldKeepHttpSession = YES;
        self.httpSessionDelegate = self;
    }
    return self;
}

- (nonnull NSString *)getUrl {
    return self.openRTBdelegate.getURL;
}

-(Boolean)shouldCancel {
    Boolean shouldCancel = [self.openRTBdelegate getImp] == nil;
    RPSLog(shouldCancel ? @"HTTP request cancelled by empty imp" : @"ready to send");
    return shouldCancel;
}

-(NSDictionary *)postJsonBody {
    return [self postBidBody];
}

- (void)onJsonResponse:(NSHTTPURLResponse *)response withData:(NSDictionary *)json {
    NSMutableArray<NSDictionary*>* bidDataList = nil;
    if (response.statusCode == 200) {
        bidDataList = [NSMutableArray array];
        RPSJSONObject* jsonObj = [RPSJSONObject jsonWithRawDictionary:json];
        for (id seatbid in [jsonObj getArray:@"seatbid"]) {
            if (seatbid && [seatbid isKindOfClass:NSDictionary.class]) {
                RPSJSONObject* jsonSeatbid = [RPSJSONObject jsonWithRawDictionary:seatbid];

                for (id bidData in [jsonSeatbid getArray:@"bid"]) {
                    if (bidData && [bidData isKindOfClass:NSDictionary.class]) {
                        [bidDataList addObject:bidData];
                    }
                }
            }
        }
    } else {
        VERBOSE_LOG(@"OpenRTB responsed status code: %ld", (long)response.statusCode);
    }

    [self.openRTBdelegate onBidResponse:response withBidList:bidDataList];
}


#pragma mark - OpenRTB Protocol
- (nonnull NSDictionary *)postBidBody {
    NSMutableDictionary* body = [NSMutableDictionary dictionary];

    if ([self.openRTBdelegate getImp]) {
        [body setObject:[self.openRTBdelegate getImp] forKey:@"imp"];
    }
    if ([self.openRTBdelegate getApp]) {
        [body setObject:[self.openRTBdelegate getApp] forKey:@"app"];
    }
    if ([self.openRTBdelegate getDevice]) {
        [body setObject:[self.openRTBdelegate getDevice] forKey:@"device"];
    }

    return body;
}

@end


