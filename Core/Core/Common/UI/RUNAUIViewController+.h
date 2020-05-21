//
//  RUNAUIViewController+.h
//  RUNA
//
//  Created by Wu, Wei b on 2019/12/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController(RUNA_UIKit)

+(UIViewController*) topViewControllerInHierarchy:(UIViewController*) rootNode;

@end

NS_ASSUME_NONNULL_END
