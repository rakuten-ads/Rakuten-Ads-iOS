//
//  RUNABannerViewAtoa.m
//  A2A
//
//  Created by Wu, Wei b on 2019/12/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNABannerViewAtoaInner.h"
#import "RUNABannerViewInner.h"
#import "RUNAPopupViewController.h"
#import <RUNACore/RUNAUIViewController+.h>
#import <RUNACore/RUNAValid.h>

@implementation RUNABannerViewAppContent
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

@implementation RUNABannerView(RUNA_Atoa)

-(void)setBannerViewAppContent:(RUNABannerViewAppContent *)appContent {
    self.appContent = [NSMutableDictionary dictionaryWithDictionary:@{
        @"title" : appContent.title ?: NSNull.null,
        @"keywords" : [appContent.keywords componentsJoinedByString:@","] ?: NSNull.null,
        @"url" : appContent.url ?: NSNull.null,
    }];
    if (!self.openPopupHandler) {
        RUNADebug("create open_popup handler");
        self.openPopupHandler = [RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeOpenPopup handle:^(RUNAAdWebViewMessage * _Nullable message) {
            RUNADebug("handle %@", message.type);
            if (message.url) {
                [self handlePopup:message.url];
            }
        }];
    }
}

-(void) handlePopup:(NSString*) url {
    NSURLComponents* urlComp = [NSURLComponents componentsWithString:url];
    if (!urlComp) {
        RUNADebug("illegal url format: %@", url);
        return;
    }

    NSMutableArray<NSURLQueryItem*>* mutableQueryItems = [urlComp.queryItems mutableCopy];
    __block BOOL hasAdspotId = false;
    [urlComp.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([item.name isEqualToString:@"id"]) {
            hasAdspotId = true;
        }
    }];
    if (!hasAdspotId && self.adSpotId) {
        RUNADebug("fill adspot Id: %@", self.adSpotId);
        [mutableQueryItems addObject:[NSURLQueryItem queryItemWithName:@"id" value:self.adSpotId]];
    }
    if (self.appContent) {
        RUNADebug("fill app content: %@", self.appContent);
        [self.appContent enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
            if ([RUNAValid isNotEmptyString:obj]) {
                [mutableQueryItems addObject:[NSURLQueryItem queryItemWithName:key value:obj]];
            }
        }];
    }
    urlComp.queryItems = mutableQueryItems;
    NSURL* nsurl = urlComp.URL;
    if (nsurl) {
        RUNADebug("open popup url: %@", nsurl);
        RUNAPopupViewController* popupViewController = [[RUNAPopupViewController alloc] initWithNibName:@"RUNAPopup" bundle:[NSBundle bundleForClass:RUNAPopupViewController.class]];
        popupViewController.url = nsurl;
        if (@available(iOS 13.0, *)) {
            popupViewController.modalInPresentation = YES;
        }

        UIViewController* root = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController* top = [UIViewController topViewControllerInHierarchy:root];
        [top presentViewController:popupViewController animated:YES completion:nil];
    }
}

@end
