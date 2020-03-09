//
//  RUNAURLString.h
//  RUNA
//
//  Created by Wu, Wei b on 2019/08/23.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RUNACore/RUNAHttpTask.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString RUNAURLString;

#pragma mark - NSString extension
@interface NSString (RUNASDK) <RUNAHttpTaskDelegate>

@end


@interface RUNAURLStringRequest : RUNAHttpTask

@end

NS_ASSUME_NONNULL_END
