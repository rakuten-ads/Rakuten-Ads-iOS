//
//  RUNAAdWebViewMessageHandler.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/12/16.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNAAdWebViewMessage.h"
#import <RUNACore/RUNAJSONObject.h>

NSString* kSdkMessageTypeOther = @"other";
NSString* kSdkMessageTypeExpand = @"expand";
NSString* kSdkMessageTypeCollapse = @"collapse";
NSString* kSdkMessageTypeRegister = @"register";
NSString* kSdkMessageTypeUnfilled = @"unfilled";
NSString* kSdkMessageTypeOpenPopup = @"open_popup";
NSString* kSdkMessageTypeVideo = @"video";
NSString* kSdkMessageTypeVideoLoaded = @"video_loaded";
NSString* kSdkMessageTypeClose = @"close";

@implementation RUNAAdWebViewMessage

+(instancetype) parse:(NSDictionary*) data {
    RUNAJSONObject* json = [RUNAJSONObject jsonWithRawDictionary:data];
    RUNAAdWebViewMessage* message = [RUNAAdWebViewMessage new];
    message->_vendor = [json getString:@"vendor"];
    message->_type = [json getString:@"type"];
    message->_url = [json getString:@"url"];
    return message;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"{ "
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

@implementation RUNAAdWebViewMessageHandler

- (instancetype)initWithType:(NSString *)type handle:(RUNAAdWebViewMessageHandle)handle {
    self = [super init];
    if (self) {
        self->_type = [type copy];
        self->_handle = [handle copy];
    }
    return self;
}

+ (instancetype)messageHandlerWithType:(NSString *)type handle:(RUNAAdWebViewMessageHandle)handle {
    RUNAAdWebViewMessageHandler* handler = [[RUNAAdWebViewMessageHandler alloc] initWithType:type handle:handle];
    return handler;
}

@end
