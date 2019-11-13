//
//  RPSBannerModel.h
//  RDN
//
//  Created by Wu, Wei b on 2019/10/25.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RPSAdWebViewMessage : NSObject

@property(nonatomic, readonly) NSString* vendor;
@property(nonatomic, readonly) NSString* type;

+(instancetype) parse:(NSDictionary*) data;

@end
NS_ASSUME_NONNULL_END
