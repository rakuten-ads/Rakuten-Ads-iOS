//
//  RUNAAdWebViewMessageHandler.h
//  RUNA
//
//  Created by Wu, Wei b on 2019/12/16.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *kSdkMessageTypeOther;
FOUNDATION_EXPORT NSString *kSdkMessageTypeExpand;
FOUNDATION_EXPORT NSString *kSdkMessageTypeCollapse;
FOUNDATION_EXPORT NSString *kSdkMessageTypeRegister;
FOUNDATION_EXPORT NSString *kSdkMessageTypeUnfilled;
FOUNDATION_EXPORT NSString *kSdkMessageTypeOpenPopup;
FOUNDATION_EXPORT NSString *kSdkMessageTypeVideo;
FOUNDATION_EXPORT NSString *kSdkMessageTypeVideoLoaded;

@interface RUNAAdWebViewMessage : NSObject

@property(nonatomic, readonly) NSString* vendor;
@property(nonatomic, readonly) NSString* type;
@property(nonatomic, readonly, nullable) NSString* url;

+(instancetype) parse:(NSDictionary*) data;

@end


typedef void (^RUNAAdWebViewMessageHandle)(RUNAAdWebViewMessage* __nullable message);

@interface RUNAAdWebViewMessageHandler : NSObject

@property(nonatomic, readonly, copy) NSString* type;
@property(nonatomic, readonly, copy) RUNAAdWebViewMessageHandle handle;

+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;

-(instancetype) initWithType:(NSString*) type handle:(RUNAAdWebViewMessageHandle) handle;
+(instancetype) messageHandlerWithType:(NSString*) type handle:(RUNAAdWebViewMessageHandle) handle;

@end

NS_ASSUME_NONNULL_END
