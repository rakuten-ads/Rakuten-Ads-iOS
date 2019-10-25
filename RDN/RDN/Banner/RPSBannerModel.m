//
//  RPSBannerModel.m
//  RDN
//
//  Created by Wu, Wei b on 2019/10/25.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSBannerModel.h"
#import <RPSCore/RPSJSONObject.h>


@implementation RPSAdWebViewMessage

+(instancetype) parse:(NSDictionary*) data {
    RPSJSONObject* json = [RPSJSONObject jsonWithRawDictionary:data];
    RPSAdWebViewMessage* message = [RPSAdWebViewMessage new];
    message->_vender = [json getString:@"vendor"];
    message->_type = [json getString:@"type"];
    return message;
}

@end
