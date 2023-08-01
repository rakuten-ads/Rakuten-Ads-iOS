//
//  RUNAViewabilityProvider.h
//  Banner
//
//  Created by Wu, Wei | David on 2021/05/26.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <RUNABanner/RUNAMeasurableTarget.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 Provides view-ability measurement to a target of native  view.
 */
@interface RUNAViewabilityProvider : NSObject

/*!
 Singleton instance
 */
+(instancetype) sharedInstance;

/*!
 Register and refer a measure target and start measurement.
 Call method -unregisterTarget: to release the memory referance when measurement is no longer needed.
 - Parameters:
   - target: measure target.
 */
-(void) registerTarget:(RUNAMeasurableTarget*) target;

/*!
 Unregister the measure target to release the memory reference.
 - Parameters:
   - target: measure target.
 */
-(void) unregisterTarget:(RUNAMeasurableTarget*) target;

/*!
 Deprecated, use -registerTarget:.
 Register view with RUNA measurement only.
 - Parameters:
   - url: URL automatically sent to server when view-ability is detected.
   - handler: A custom handler for view-ability detected event.
 */
-(void) registerTargetView:(UIView*) view withViewImpURL:(nullable NSString*) url completionHandler:(nullable RUNAViewabilityCompletionHandler) handler DEPRECATED_MSG_ATTRIBUTE("Use -registerTarget:");

/*!
 Deprecated for typo, use -unregisterTargetView:
 Unregister the target view, same as -unregisterTargetView:.
 - Parameters:
   - target: measure target view.
 */
-(void) unregsiterTargetView:(UIView*) view DEPRECATED_MSG_ATTRIBUTE("Use -unregisterTargetView:");

/*!
 Unregister the target view.
 - Parameters:
   - target: measure target view.
 */
-(void) unregisterTargetView:(UIView*) view;

@end

NS_ASSUME_NONNULL_END
