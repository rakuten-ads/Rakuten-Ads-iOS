//
//  RUNABannerView+Mock.m
//  Banner
//
//  Created by Sato, Akihiko | Akkie on 2021/05/25.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNABannerView+Mock.h"

@interface RUNABanner (Mock)
- (void)parse:(NSDictionary *)bidData;
@end

@implementation RUNABannerView (Mock)

- (instancetype)initWithEventType:(NSString *)type {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        NSMutableDictionary *bidData = [[NSMutableDictionary alloc]initWithDictionary:[RUNABannerView dummyBidData]];
        bidData[@"adm"] = [self adm:type];
        RUNABanner *banner = [RUNABanner new];
        [banner parse:(NSDictionary*)bidData];
        [self setValue:banner forKey:@"banner"];
        [self setValue:@YES forKey:@"openMeasurementDisabled"];
    }
    return self;
}

- (instancetype)initWithBidData {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        RUNABanner *banner = [RUNABanner new];
        [banner parse:[RUNABannerView dummyBidData]];
        [self setValue:banner forKey:@"banner"];
        [self setValue:@YES forKey:@"openMeasurementDisabled"];
    }
    return self;
}

- (NSString *)adm:(NSString *)type {
    NSString *path = [[NSBundle bundleForClass:[self class]]pathForResource:@"mock" ofType:@"js"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *script = [[NSString alloc]initWithBytes:[data bytes]
                                               length:[data length]
                                             encoding:NSUTF8StringEncoding];
    NSString *replaced = [script stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return [NSString stringWithFormat:replaced, type];
}

+ (NSDictionary *)dummyBidData {
    NSString *path = [[NSBundle bundleForClass:[self class]]pathForResource:@"bid" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];;
    return dic;
}

@end
