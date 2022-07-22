//
//  RUNABannerViewAtoa.m
//  A2A
//
//  Created by Wu, Wei b on 2019/12/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNABannerViewAtoa.h"
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

-(void)a2a_active {
    RUNADebug("active SDK RUNA/A2A version: %@", self.a2a_versionString);
    RUNADebug("create open_popup handler");
    __weak RUNABannerView* weakSelf = self;
    RUNAAdWebViewMessageHandler* openPopupHandler = [RUNAAdWebViewMessageHandler messageHandlerWithType:kSdkMessageTypeOpenPopup handle:^(RUNAAdWebViewMessage * _Nullable message) {
        RUNADebug("handle %@", message.type);
        __strong RUNABannerView* strongSelf = weakSelf;
        if (message.url) {
            [strongSelf handlePopup:message.url];
        }
        if (strongSelf.eventHandler) {
            @try {
                struct RUNABannerViewEvent event = { RUNABannerViewEventTypeClicked, strongSelf.error };
                strongSelf.eventHandler(strongSelf, event);
            } @catch (NSException *exception) {
                RUNADebug("exception on popup event: %@", exception);
                [strongSelf a2a_sendRemoteLogWithMessage:@"exception on popup event" andException:exception];
            }
        }
    }];
    [self.webView addMessageHandler:openPopupHandler];
}

-(void)setBannerViewAppContent:(RUNABannerViewAppContent *)appContent {
    self.appContent = @{
        @"title" : appContent.title ?: NSNull.null,
        @"keywords" : [appContent.keywords componentsJoinedByString:@","] ?: NSNull.null,
        @"url" : appContent.url ?: NSNull.null,
    };
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
            if (obj != NSNull.null && [RUNAValid isNotEmptyString:obj]) {
                [mutableQueryItems addObject:[NSURLQueryItem queryItemWithName:key value:obj]];
            }
        }];
    }
    if (self.geo) {
        RUNADebug("fill geo: lat=%f, lon=%f", self.geo.latitude, self.geo.longitude);
        [mutableQueryItems addObject:[NSURLQueryItem queryItemWithName:@"latitude" value:[NSString stringWithFormat:@"%f", self.geo.latitude]]];
        [mutableQueryItems addObject:[NSURLQueryItem queryItemWithName:@"longitude" value:[NSString stringWithFormat:@"%f", self.geo.longitude]]];
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

-(void) a2a_sendRemoteLogWithMessage:(NSString*) message andException:(NSException*) exception {
    RUNARemoteLogEntityErrorDetail* error = [RUNARemoteLogEntityErrorDetail new];
    error.errorMessage = [message stringByAppendingFormat:@": [%@] %@ { userInfo: %@ }", exception.name, exception.reason, exception.userInfo];
    error.stacktrace = exception.callStackSymbols;
    error.tag = @"RUNAA2A";
    error.ext = self.descriptionDetail;
    
    // user info
    self.logUserInfo = nil;
    
    // ad info
    self.logAdInfo.adspotId = self.adSpotId;
    self.logAdInfo.sessionId = self.sessionId;
    self.logAdInfo.sdkVersion = self.a2a_versionString;
    
    RUNARemoteLogEntity* log = [RUNARemoteLogEntity logWithError:error andUserInfo:self.logUserInfo adInfo:self.logAdInfo];
    [RUNARemoteLogger.sharedInstance sendLog:log];
}

// TODO: This method doesn't not work in a real app.
-(NSString*) a2a_versionString {
    return [[[NSBundle bundleForClass:[RUNAPopupViewController class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
