//
//  RPSAdSpotInfo.m
//  RsspSDK
//
//  Created by Wu Wei on 2018/07/24.
//  Copyright © 2018 LOB. All rights reserved.
//

#import "RPSAdSpotInfo.h"
#import <RPSCore/RPSJSONObject.h>

@implementation RPSAdSpotInfo

+(instancetype)adSpotInfoFrom:(NSDictionary *)json {
    RPSAdSpotInfo* adSpotInfo = nil;
    if (json) {
        RPSJSONObject* jsonObj = [RPSJSONObject jsonWithRawDictionary:json];
        adSpotInfo = [RPSAdSpotInfo new];
        
        adSpotInfo->_adSpotId = [jsonObj getString:@"adspot_id"];
        adSpotInfo->_html = [jsonObj getString:@"html"];
        adSpotInfo->_width = [[jsonObj getNumber:@"width"] floatValue];
        adSpotInfo->_height = [[jsonObj getNumber:@"height"] floatValue];
    }
    
    return adSpotInfo;
}

-(NSString *)description {
    return [NSString stringWithFormat:
            @"\n"
            @"adspot id: %@\n"
            @"html: %@\n"
            @"width: %f\n"
            @"height: %f\n"
            ,
            self.adSpotId,
            self.html,
            self.width,
            self.height,
            nil];
}

@end
