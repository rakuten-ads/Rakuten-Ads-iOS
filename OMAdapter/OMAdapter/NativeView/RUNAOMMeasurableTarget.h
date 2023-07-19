//
//  RUNAOMNativeTarget.h
//  OMAdapter
//
//  Created by Wu, Wei | David | GATD on 2023/06/02.
//  Copyright © 2023 RUNA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RUNAMeasurement.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^RUNAImpCompletionHandler)(UIView* view);

@interface RUNAOMMeasurableTarget : NSObject<RUNAOpenMeasurement>

@property(nonatomic, readonly) NSString* identifier;
@property(nonatomic, weak, readonly) UIView* view;

@property(nonatomic) id<RUNAMeasurer> measurer;
@property(nonatomic, copy, nullable) RUNAImpCompletionHandler completionHandler;

- (instancetype)initWithView:(UIView*) view;

@end

NS_ASSUME_NONNULL_END
