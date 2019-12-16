//
//  RPSAdWebViewMessageHandler.h
//  RDN
//
//  Created by Wu, Wei b on 2019/12/16.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *kSdkMessageHandlerName;
FOUNDATION_EXPORT NSString *kSdkMessageTypeOther;
FOUNDATION_EXPORT NSString *kSdkMessageTypeExpand;
FOUNDATION_EXPORT NSString *kSdkMessageTypeCollapse;
FOUNDATION_EXPORT NSString *kSdkMessageTypeRegister;
FOUNDATION_EXPORT NSString *kSdkMessageTypeOpenPopup;


@interface RPSAdWebViewMessage : NSObject

@property(nonatomic, readonly) NSString* vendor;
@property(nonatomic, readonly) NSString* type;
@property(nonatomic, readonly, nullable) NSString* url;

+(instancetype) parse:(NSDictionary*) data;

@end


typedef void (^RPSAdWebViewMessageHandle)(RPSAdWebViewMessage* __nullable message);
@interface RPSAdWebViewMessageHandler : NSObject

@property(nonatomic, readonly) NSString* type;
@property(nonatomic, readonly) RPSAdWebViewMessageHandle handle;

+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;

+(instancetype) messageHandlerWithType:(NSString*) type handler:(RPSAdWebViewMessageHandle) handle;

@end

NS_ASSUME_NONNULL_END
