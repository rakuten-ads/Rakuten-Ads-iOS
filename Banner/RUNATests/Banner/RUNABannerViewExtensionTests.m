//
//  RUNABannerViewExtensionTests.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/23.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNABannerViewExtension.h"
#import "RUNABannerViewInner.h"

@interface RUNABannerViewGenreProperty (Spy)
- (instancetype)initWithEmpty;
@end

@implementation RUNABannerViewGenreProperty (Spy)
- (instancetype)initWithEmpty {
    return self = [super init];
}
@end

@interface RUNABannerView (Spy)
- (void)setPropertyGenre:(nullable RUNABannerViewGenreProperty *)matchingGenre;
- (void)setCustomTargeting:(nullable NSDictionary *)target;
- (void)setRz:(nullable NSString *)rz;
- (BOOL)isValidLat:(double)lat;
- (BOOL)isValidLon:(double)lon;
- (BOOL)isValidLocation:(double)lat longitude:(double)lon;
- (void)setLocationWithLatitude:(double)lat longitude:(double)lon;
@end

@interface RUNABannerViewExtensionTests : XCTestCase
@property (nonatomic) RUNABannerViewGenreProperty *actual;
@end

@implementation RUNABannerViewExtensionTests
@synthesize actual = _actual;

- (void)setUp {
    self.actual = [[RUNABannerViewGenreProperty alloc]initWithMasterId:999 code:@"code" match:@"match"];
}

- (void)testInitWithMasterId {
    RUNABannerViewGenreProperty *actual = self.actual;
    XCTAssertEqual(actual.masterId, 999);
    XCTAssertEqualObjects(actual.code, @"code");
    XCTAssertEqualObjects(actual.match, @"match");
}

- (void)testSetPropertyGenre {
    {
        // Case: Default
        RUNABannerView *bannerView = [RUNABannerView new];
        [bannerView setPropertyGenre:self.actual];
        NSDictionary *genre = bannerView.imp.json[@"genre"];
        XCTAssertNotNil(genre);
        XCTAssertEqual(genre.allKeys.count, (NSUInteger)3);
        XCTAssertEqual(genre[@"master_id"], [NSNumber numberWithInteger:999]);
        XCTAssertEqualObjects(genre[@"code"], @"code");
        XCTAssertEqualObjects(genre[@"match"], @"match");
    }
    {
        // Case: Empty
        RUNABannerView *bannerView = [RUNABannerView new];
        RUNABannerViewGenreProperty *stub = [[RUNABannerViewGenreProperty alloc]initWithEmpty];
        [bannerView setPropertyGenre:stub];
        NSDictionary *genre = bannerView.imp.json[@"genre"];
        XCTAssertNotNil(genre);
        XCTAssertEqual(genre.allKeys.count, (NSUInteger)3);
        XCTAssertEqual(genre[@"master_id"], [NSNumber numberWithInteger:0]);
        XCTAssertEqualObjects(genre[@"code"], NSNull.null);
        XCTAssertEqualObjects(genre[@"match"], NSNull.null);
    }
    {
        // Case: Null
        RUNABannerView *bannerView = [RUNABannerView new];
        [bannerView setPropertyGenre:nil];
        NSDictionary *genre = bannerView.imp.json[@"genre"];
        XCTAssertNil(genre);
    }
}

- (void)testSetCustomTargeting {
    {
        // Case: Default
        RUNABannerView *bannerView = [RUNABannerView new];
        [bannerView setCustomTargeting:@{@"key":@"value"}];
        NSDictionary *target = bannerView.imp.json[@"targeting"];
        XCTAssertNotNil(target);
        XCTAssertEqualObjects(target[@"key"], @"value");
    }
    {
        // Case: Empty
        RUNABannerView *bannerView = [RUNABannerView new];
        [bannerView setCustomTargeting:@{}];
        NSDictionary *target = bannerView.imp.json[@"targeting"];
        XCTAssertNotNil(target);
        XCTAssertEqual(target.allKeys.count, (NSUInteger)0);
    }
    {
        // Case: Null
        RUNABannerView *bannerView = [RUNABannerView new];
        [bannerView setCustomTargeting:nil];
        NSDictionary *target = bannerView.imp.json[@"targeting"];
        XCTAssertNil(target);
    }
}

- (void)testSetRz {
    {
        // Case: Default
        RUNABannerView *bannerView = [RUNABannerView new];
        [bannerView setRz:@"cokie"];
        NSDictionary *userExt = bannerView.userExt;
        XCTAssertNotNil(userExt);
        XCTAssertEqual(userExt.allKeys.count, (NSUInteger)1);
        XCTAssertEqualObjects(userExt[@"rz"], @"cokie");
    }
    {
        // Case: Empty
        RUNABannerView *bannerView = [RUNABannerView new];
        [bannerView setRz:@""];
        NSDictionary *userExt = bannerView.userExt;
        XCTAssertNil(userExt);
    }
    {
        // Case: Null
        RUNABannerView *bannerView = [RUNABannerView new];
        [bannerView setRz:nil];
        NSDictionary *userExt = bannerView.userExt;
        XCTAssertNil(userExt);
    }
}

- (void)testIsValidLat {
    NSArray *params = @[
        @{ @"value": @(-91), @"expected": @NO },
        @{ @"value": @(-90), @"expected": @YES },
        @{ @"value": @(0), @"expected": @YES },
        @{ @"value": @(90), @"expected": @YES },
        @{ @"value": @(91), @"expected": @NO }
    ];
    
    RUNABannerView *bannerView = [RUNABannerView new];
    
    [params enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull param, NSUInteger idx, BOOL * _Nonnull stop) {
        double lat = ((NSNumber*)param[@"value"]).doubleValue;
        BOOL expected =  ((NSNumber*)param[@"expected"]).boolValue;
        XCTAssertEqual([bannerView isValidLat:lat], expected);
    }];
}

- (void)testIsValidLon {
    NSArray *params = @[
        @{ @"value": @(-181), @"expected": @NO },
        @{ @"value": @(-180), @"expected": @YES },
        @{ @"value": @(0), @"expected": @YES },
        @{ @"value": @(180), @"expected": @YES },
        @{ @"value": @(181), @"expected": @NO }
    ];
    
    RUNABannerView *bannerView = [RUNABannerView new];
    
    [params enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull param, NSUInteger idx, BOOL * _Nonnull stop) {
        double lon = ((NSNumber*)param[@"value"]).doubleValue;
        BOOL expected =  ((NSNumber*)param[@"expected"]).boolValue;
        XCTAssertEqual([bannerView isValidLon:lon], expected);
    }];
}

- (void)testSetLocationWithLatitude {
    NSArray *params = @[
        @{ @"lat": @(90), @"lon": @(180), @"expected": @YES },
        @{ @"lat": @(90), @"lon": @(181), @"expected": @NO },
        @{ @"lat": @(91), @"lon": @(180), @"expected": @NO },
        @{ @"lat": @(91), @"lon": @(181), @"expected": @NO }
    ];
    
    [params enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull param, NSUInteger idx, BOOL * _Nonnull stop) {
        double lat = ((NSNumber*)param[@"lat"]).doubleValue;
        double lon = ((NSNumber*)param[@"lon"]).doubleValue;
        BOOL expected =  ((NSNumber*)param[@"expected"]).boolValue;
        
        RUNABannerView *bannerView = [RUNABannerView new];
        [bannerView setLocationWithLatitude:lat longitude:lon];
        RUNAGeo *geo = bannerView.geo;
        
        if (expected) {
            XCTAssertNotNil(geo);
            XCTAssertEqual(geo.latitude, lat);
            XCTAssertEqual(geo.longitude, lon);
        } else {
            XCTAssertNil(geo);
        }
    }];
}

@end
