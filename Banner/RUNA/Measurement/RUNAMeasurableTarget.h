//
//  RUNAMeasurableTarget.h
//  Banner
//
//  Created by Wu, Wei | David | GATD on 2023/07/20.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUNABanner/RUNAMeasurement.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^RUNAViewabilityCompletionHandler)(UIView* view);

/*!
 Configuration for RUNA measurement
 */
@interface RUNAMeasurementConfiguration : NSObject

/// URL to be sent when view imp detected
@property(nonatomic, copy, nullable) NSString* viewImpURL;

/// Custom handler for view imp detected event
@property(nonatomic, copy, nullable) RUNAViewabilityCompletionHandler completionHandler;

@end


/*!
 A target object supported by RUNA measurement
 */
@interface RUNAMeasurableTarget : NSObject<RUNADefaultMeasurement, RUNAMeasurerDelegate>

/// identify the object
@property(nonatomic, readonly) NSString* identifier;

/// target view
@property(nonatomic, readonly, weak) UIView* view;

/// enabled measurer list
@property(nonatomic, readonly) NSMutableDictionary<NSString*, id<RUNAMeasurer>>* measurers;

-(instancetype)init NS_UNAVAILABLE;
+(instancetype)new NS_UNAVAILABLE;

/*!
 initial with a target view
 @Param view target view
 */
- (instancetype)initWithView:(UIView*) view;

/*!
 Set the configuration for RUNA measurement to enable.
 */
-(void) setRUNAMeasurementConfiguration:(RUNAMeasurementConfiguration*) config;

@end

NS_ASSUME_NONNULL_END
