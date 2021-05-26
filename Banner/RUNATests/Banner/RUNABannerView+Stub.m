//
//  RUNABannerView+Stub.m
//  Banner
//
//  Created by Sato, Akihiko | Akkie on 2021/05/25.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNABannerView+Stub.h"

@interface RUNABanner (Stub)
- (void)parse:(NSDictionary *)bidData;
@end

@implementation RUNABannerView (Stub)

- (instancetype)initWithBidResponse:(NSDictionary *)response {
    self = [self init];
    if (self) {
        RUNABanner *banner = [RUNABanner new];
        [banner parse:response];
        [self setValue:banner forKey:@"banner"];
        [self setValue:@YES forKey:@"openMeasurementDisabled"];
    }
    return self;
}

@end
