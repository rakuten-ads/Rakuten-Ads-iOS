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

@property(nonatomic, nullable) NSString* tag;
@property(nonatomic, nullable) NSString* errorMessage;
@property(nonatomic, nullable) NSString* stacktrace;
@property(nonatomic, nullable) NSDictionary* ext;

-(NSDictionary*) toDictionary;

@end

@interface RUNARemoteLogEntityUser : NSObject

@property(nonatomic, nullable) NSString* id;
@property(nonatomic, nullable) NSDictionary* ext;

-(NSDictionary*) toDictionary;

@end

@interface RUNARemoteLogEntityAd : NSObject

@property(nonatomic, nullable) NSString* adspotId;
@property(nonatomic, nullable) NSArray<NSString*>* batchAdspotList;
@property(nonatomic, nullable) NSString* sessionId;

-(NSDictionary*) toDictionary;

@end

@interface RUNARemoteLogEntity : NSObject

@property(nonatomic) RUNARemoteLogEntityErrorDetail* errorDetail;
@property(nonatomic, nullable) RUNARemoteLogEntityUser* userInfo;
@property(nonatomic, nullable) RUNARemoteLogEntityAd* adInfo;

+(instancetype) logWithError:(RUNARemoteLogEntityErrorDetail*) errorDetail andUserInfo: (nullable RUNARemoteLogEntityUser*) userInfo adInfo:(nullable RUNARemoteLogEntityAd*) adInfo;

@end

NS_ASSUME_NONNULL_END
