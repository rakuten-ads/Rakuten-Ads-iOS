//
//  Core.h
//  Core
//
//  Created by Wu, Wei b on 2019/01/09.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Core.
FOUNDATION_EXPORT double RPSCoreVersionNumber;

//! Project version string for Core.
FOUNDATION_EXPORT const unsigned char RPSCoreVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <RPSCore/PublicHeader.h>

@interface RPSCore : NSObject

+(NSString*) sdkBundleVersionShortString;

@end
