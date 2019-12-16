//
//  RPSAdWebViewMessageHandler.m
//  RDN
//
//  Created by Wu, Wei b on 2019/12/16.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSAdWebViewMessage.h"
#import "RPSPopupViewController.h"
#import <RPSCore/RPSJSONObject.h>

NSString *kSdkMessageHandlerName = @"rpsSdkInterface";
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
    return [NSString stringWithFormat:@"vendor: %@\n"
            @"type: %@"
            @"url:n %@"
            ,
            self.vendor,
            self.type,
            self.url,
            nil];
}

-(void)handleMessage:(RPSAdWebViewMessage *)message {

}

#pragma mark - implement WKScriptMessageHandler

//-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    RPSDebug("received posted message %@", [message debugDescription]);
//    if ([message.name isEqualToString:kSdkMessageHandlerName]
//        && message.body) {
//        @try {
//            if ([message.body isKindOfClass:[NSDictionary class]]) {
//                RPSAdWebViewMessage* sdkMessage = [RPSAdWebViewMessage parse:(NSDictionary*)message.body];
//                RPSDebug("sdk message %@", sdkMessage);
//                if ([sdkMessage.type isEqualToString:kSdkMessageTypeRegister]) {
//                    self.state = RPS_ADVIEW_STATE_MESSAGE_LISTENING;
//                } else if ([sdkMessage.type isEqualToString:kSdkMessageTypeExpand]) {
//                    [self triggerSuccess];
//                } else if ([sdkMessage.type isEqualToString:kSdkMessageTypeCollapse]) {
//                    [self triggerFailure];
//                } else if ([sdkMessage.type isEqualToString:kSdkMessageTypeOpenPopup]) {
//                    [self handlePopup:sdkMessage.url];
//                }
//            } else {
//                RPSDebug("%@", message.body);
//            }
//        } @catch (NSException *exception) {
//            RPSDebug("exception when waiting post message: %@", exception);
//            [self triggerFailure];
//        }
//    }
//}

-(void) handlePopup:(NSString*) url {
    RPSDebug("open popup url: %@", url);
    NSURL* nsurl = [NSURL URLWithString:url];
    if (nsurl) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"RPSPopup" bundle:[NSBundle bundleForClass:self.class]];
        RPSPopupViewController* popupViewController = (RPSPopupViewController*)[storyboard instantiateInitialViewController];
        UIViewController* root = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController* top = [self topViewControllerFrom:root];
        [top presentViewController:popupViewController animated:YES completion:nil];
    }
}

-(UIViewController*) topViewControllerFrom:(UIViewController*) viewController {
    UIViewController* current = viewController;
    UIViewController* top = current;
    while (current) {
        top = current;
        if ([current isKindOfClass:[UITabBarController class]]) {
            current = ((UITabBarController*)current).selectedViewController;
        } else if ([viewController isKindOfClass:[UINavigationController class]]) {
            current = ((UINavigationController*)current).visibleViewController;
        } else if (viewController.presentedViewController) {
            current = current.presentedViewController;
        }
    }
    return top;
}

@end
