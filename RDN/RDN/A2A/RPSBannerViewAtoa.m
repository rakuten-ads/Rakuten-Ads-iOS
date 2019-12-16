//
//  RPSBannerViewAtoa.m
//  RDN
//
//  Created by Wu, Wei b on 2019/12/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSBannerViewAtoa.h"
#import "RPSBannerViewInner.h"

@implementation RPSBannerViewAppContent
-(instancetype) initWithTitle:(NSString *)title keywords:(NSArray<NSString *> *)keywords url:(NSString *)url {
    self = [super init];
    if (self) {
        self->_title = [title copy];
        self->_keywords = [keywords copy];
        self->_url = [url copy];
    }
    return self;
}
@end

@implementation RPSBannerView(RPS_Atoa)

-(void)setBannerViewAppContent:(RPSBannerViewAppContent *)appContent {
    self.appContent = [NSMutableDictionary dictionaryWithDictionary:@{
        @"title" : appContent.title ?: NSNull.null,
        @"keywords" : [appContent.keywords componentsJoinedByString:@","] ?: NSNull.null,
        @"url" : appContent.url ?: NSNull.null,
    }];
}

@end
