//
//  RPSUIViewController+.m
//  RDN
//
//  Created by Wu, Wei b on 2019/12/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RPSUIViewController+.h"

@implementation UIViewController(RPS_UIKit)

+(UIViewController*) topViewControllerInHierarchy:(UIViewController*) rootNode {
    UIViewController* current = rootNode;
    UIViewController* top = current;
    while (current) {
        top = current;
        if ([current isKindOfClass:[UITabBarController class]]) {
            current = ((UITabBarController*)current).selectedViewController;
        } else if ([current isKindOfClass:[UINavigationController class]]) {
            current = ((UINavigationController*)current).visibleViewController;
        } else if ([current isKindOfClass:[UISplitViewController class]]){
            current = ((UISplitViewController*)current).childViewControllers.lastObject;
        } else {
            current = current.presentedViewController;
        }
    }
    return top;
}

@end
