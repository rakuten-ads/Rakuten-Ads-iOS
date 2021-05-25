//
//  RUNABannerView+Stub.m
//  Banner
//
//  Created by Sato, Akihiko | Akkie on 2021/05/25.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNABannerView+Stub.h"
#import "RUNABanner+Stub.h"

@interface RUNABanner (Stub)
- (void)parse:(NSDictionary *)bidData;
@end

@implementation RUNABannerView (Stub)

- (instancetype)initWithBidResponse:(NSDictionary *)response {
    self = [self init];
    if (self) {
        RUNABanner *banner = [RUNABanner alloc]initWithHtml:@"dummyHTML";
        [banner parse:response];
        [self setValue:banner forKey:@"banner"];
    }
    return self;
}

@end
