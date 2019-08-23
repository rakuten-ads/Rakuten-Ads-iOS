//
//  RPSURLString.h
//  RDN
//
//  Created by Wu, Wei b on 2019/08/23.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RPSCore/RPSHttpTask.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString RPSURLString;

#pragma mark - NSString extension
@interface NSString (RPSSDK) <RPSHttpTaskDelegate>

@end


@interface RPSURLStringRequest : RPSHttpTask

@end

NS_ASSUME_NONNULL_END
