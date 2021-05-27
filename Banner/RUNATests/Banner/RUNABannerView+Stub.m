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

- (instancetype)initWithEventType:(NSString *)type {
    self = [self init];
    if (self) {
        RUNABanner *banner = [RUNABanner new];
        [banner parse:[self dummyResponse:type]];
        [self setValue:banner forKey:@"banner"];
        [self setValue:@YES forKey:@"openMeasurementDisabled"];
    }
    return self;
}

- (NSDictionary *)dummyResponse:(NSString *)type {
    NSString *path = [[NSBundle bundleForClass:[self class]]pathForResource:@"mock" ofType:@"js"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *script = [[NSString alloc]initWithBytes:[data bytes]
                                               length:[data length]
                                             encoding:NSUTF8StringEncoding];
    NSString *replaced = [script stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return @{@"adm": [NSString stringWithFormat:replaced, type]};
}

@end
