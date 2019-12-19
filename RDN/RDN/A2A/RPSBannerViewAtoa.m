//
//  RPSBannerViewAtoa.m
//  RDN
//
//  Created by Wu, Wei b on 2019/12/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSBannerViewAtoa.h"
#import "RPSBannerViewInner.h"
#import "RPSPopupViewController.h"
#import "RPSUIViewController+.h"

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
    if (!self.openPopupHandler) {
        RPSDebug("create open_popup handler");
        self.openPopupHandler = [RPSAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeOpenPopup handle:^(RPSAdWebViewMessage * _Nullable message) {
            RPSDebug("handle %@", message.type);
            if (message.url) {
                [self handlePopup:message.url];
            }
        }];
    }
}

-(void) handlePopup:(NSString*) url {
    RPSDebug("open popup url: %@", url);
    NSURL* nsurl = [NSURL URLWithString:url];
    if (nsurl) {
        RPSPopupViewController* popupViewController = [[RPSPopupViewController alloc] initWithNibName:@"RPSPopup" bundle:[NSBundle bundleForClass:self.class]];
        popupViewController.url = nsurl;

        UIViewController* root = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController* top = [UIViewController topViewControllerInHierarchy:root];
        [top presentViewController:popupViewController animated:YES completion:nil];
    }
}

@end
