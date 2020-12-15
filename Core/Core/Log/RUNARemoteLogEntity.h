//
//  RUNARemoteLogEntity.h
//  Core
//
//  Created by Wu, Wei | David on 2020/12/03.
//  Copyright © 2020 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNARemoteLogEntityErrorDetail : NSObject

@property(nonatomic, copy, nullable) NSString* tag;
@property(nonatomic, copy, nullable) NSString* errorMessage;
@property(nonatomic, copy, nullable) NSArray<NSString*>* stacktrace;
@property(nonatomic, copy, nullable) NSDictionary* ext;

-(NSDictionary*) toDictionary;

@end

@interface RUNARemoteLogEntityUser : NSObject<NSCopying>

@property(nonatomic, nullable) NSString* id;
@property(nonatomic, nullable) NSDictionary* ext;

-(NSDictionary*) toDictionary;

@end

@interface RUNARemoteLogEntityAd : NSObject<NSCopying>

@property(nonatomic, readonly) NSDate* timestamp;
@property(nonatomic, readonly) int sdkType;

@property(nonatomic, copy) NSString* sdkVersion;
@property(nonatomic, copy, nullable) NSString* adspotId;
@property(nonatomic, copy, nullable) NSArray<NSString*>* batchAdspotList;
@property(nonatomic, copy, nullable) NSString* sessionId;

-(NSDictionary*) toDictionary;

@end

@interface RUNARemoteLogEntity : NSObject<NSCopying>

@property(nonatomic, copy) RUNARemoteLogEntityErrorDetail* errorDetail;
@property(nonatomic, copy, nullable) RUNARemoteLogEntityUser* userInfo;
@property(nonatomic, copy, nullable) RUNARemoteLogEntityAd* adInfo;

+(instancetype) logWithError:(RUNARemoteLogEntityErrorDetail*) errorDetail andUserInfo: (nullable RUNARemoteLogEntityUser*) userInfo adInfo:(nullable RUNARemoteLogEntityAd*) adInfo;

@end

NS_ASSUME_NONNULL_END
