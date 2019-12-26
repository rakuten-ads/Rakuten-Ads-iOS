//
//  RPSAdWebViewMessageHandler.m
//  RDN
//
//  Created by Wu, Wei b on 2019/12/16.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSAdWebViewMessage.h"
#import <RPSCore/RPSJSONObject.h>

NSString *kSdkMessageTypeOther = @"other";
NSString *kSdkMessageTypeExpand = @"expand";
NSString *kSdkMessageTypeCollapse = @"collapse";
NSString *kSdkMessageTypeRegister = @"register";
NSString *kSdkMessageTypeOpenPopup = @"open_popup";

@implementation RPSAdWebViewMessage

+(instancetype) parse:(NSDictionary*) data {
    RPSJSONObject* json = [RPSJSONObject jsonWithRawDictionary:data];
    RPSAdWebViewMessage* message = [RPSAdWebViewMessage new];
    message->_vendor = [json getString:@"vendor"];
    message->_type = [json getString:@"type"];
    message->_url = [json getString:@"url"];
    return message;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"{"
            @"vendor: %@"
            @", type: %@"
            @", url: %@"
            @" }",
            self.vendor,
            self.type,
            self.url,
            nil];
}

@end

@implementation RPSAdWebViewMessageHandler

- (instancetype)initWithType:(NSString *)type handle:(RPSAdWebViewMessageHandle)handle {
    self = [super init];
    if (self) {
        self->_type = [type copy];
        self->_handle = [handle copy];
    }
    return self;
}

+ (instancetype)messageHandlerWithType:(NSString *)type handle:(RPSAdWebViewMessageHandle)handle {
    RPSAdWebViewMessageHandler* handler = [[RPSAdWebViewMessageHandler alloc] initWithType:type handle:handle];
    return handler;
}

@end
