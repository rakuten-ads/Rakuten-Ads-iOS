//
//  RUNAURLString.m
//  RUNA
//
//  Created by Wu, Wei b on 2019/08/23.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNAURLString.h"
#import "RUNADefines.h"

@implementation NSString (RUNASDK)

-(NSString*) getUrl {
    return self;
}

@end


@implementation RUNAURLStringRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_httpSession = RUNADefines.sharedInstance.httpSession;
    }
    return self;
}

-(void)processConfig:(NSMutableURLRequest *)request {
    RUNAWebUserAgent* userAgentInfo = RUNADefines.sharedInstance.userAgentInfo;
    [userAgentInfo syncResult];
    [request setValue:userAgentInfo.userAgent forHTTPHeaderField:@"User-Agent"];
}

@end
