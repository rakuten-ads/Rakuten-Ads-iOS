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

@interface RUNAMeasurementConfiguration : NSObject

@property(nonatomic, copy, nullable) NSString* viewImpURL;
@property(nonatomic, copy, nullable) RUNAViewabilityCompletionHandler completionHandler;

@end

@interface RUNAMeasurableTarget : NSObject<RUNADefaultMeasurement, RUNAMeasurerDelegate>

@property(nonatomic, readonly) NSString* identifier;
@property(nonatomic, readonly, weak) UIView* view;
@property(nonatomic, readonly) NSMutableDictionary<NSString*, id<RUNAMeasurer>>* measurers;

-(instancetype)init NS_UNAVAILABLE;
+(instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithView:(UIView*) view;
-(void) setRUNAMeasurementConfiguration:(RUNAMeasurementConfiguration*) config;

@end

NS_ASSUME_NONNULL_END
