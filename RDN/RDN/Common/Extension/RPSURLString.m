//
//  RPSURLString.m
//  RDN
//
//  Created by Wu, Wei b on 2019/08/23.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSURLString.h"
#import "RPSDefines.h"

@implementation NSString (RPSSDK)

-(NSString*) getUrl {
    return self;
}

@end


@implementation RPSURLStringRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_httpSession = RPSDefines.sharedInstance.httpSession;
    }
    return self;
}

-(void)processConfig:(NSMutableURLRequest *)request {
    RPSWebUserAgent* userAgentInfo = RPSDefines.sharedInstance.userAgentInfo;
    [userAgentInfo syncResult];
    [request setValue:userAgentInfo.userAgent forHTTPHeaderField:@"User-Agent"];
}

@end
