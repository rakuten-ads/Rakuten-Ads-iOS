//
//  RUNAAdWebViewMessageManager.h
//  Core
//
//  Created by Wu, Wei | David on 2021/06/08.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUNAAdWebViewMessage.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAAdWebViewMessageManager : NSObject<WKScriptMessageHandler>

@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) NSMutableDictionary<NSString*, RUNAAdWebViewMessageHandler*>* messageHandlers;

-(instancetype)initWithName:(NSString*) name;

-(void)addMessageHandler:(RUNAAdWebViewMessageHandler *)handler;

@end

NS_ASSUME_NONNULL_END
