//
//  AdWebView.h
//  RPSSDK
//
//  Created by Wu Wei on 2018/07/23.
//  Copyright © 2018 LOB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RPSAdWebView : WKWebView

-(instancetype)initWithFrame:(CGRect)frame;

@end

@interface RPSAdWebViewMessage : NSObject

@property(nonatomic, readonly) NSString* vender;
@property(nonatomic, readonly) NSString* type;

+(instancetype) parse:(NSDictionary*) data;

@end

NS_ASSUME_NONNULL_END
