//
//  RUNAOpenMeasurerProvider.h
//  OMAdapter
//
//  Created by Wu, Wei b on R 2/07/19.
//  Copyright © Reiwa 2 RUNA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUNACore/RUNAHttpTask.h>
#import <RUNACore/RUNACacheFile.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAOpenMeasurerProvider : NSObject<RUNAHttpTaskDelegate>

@property(nonatomic, readonly) NSString* url;
@property(nonatomic, readonly) RUNACacheFile* cacheFile;

-(instancetype) initWithURL:(NSString*) url;

@end

NS_ASSUME_NONNULL_END
