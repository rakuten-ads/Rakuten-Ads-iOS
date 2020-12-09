//
//  RUNARemoteLogger.h
//  Core
//
//  Created by Wu, Wei | David on 2020/12/01.
//  Copyright © 2020 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUNARemoteLogEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNARemoteLogger : NSObject

+(instancetype) sharedInstance;

-(void) sendLog:(RUNARemoteLogEntity*) logInfo;

@end

NS_ASSUME_NONNULL_END
