//
//  RUNACacheFile.h
//  Core
//
//  Created by Wu, Wei b on R 2/07/17.
//  Copyright © Reiwa 2 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNACacheFile : NSObject

@property(nonatomic, readonly) NSString* fileName;
@property(nonatomic, readonly) NSString* abstractPath;

-(instancetype) initWithName:(NSString*) fileName;

-(BOOL) isExist;
-(BOOL) writeData:(NSData*) data;
-(nullable NSString *)readStringWithError:(NSError* _Nullable *) error;

@end

NS_ASSUME_NONNULL_END
