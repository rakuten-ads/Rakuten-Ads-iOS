//
//  RUNABannerViewExtensionTest.m
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
-(void) setPropertyGenre:(nullable RUNABannerViewGenreProperty*) matchingGenre;
@end

@interface RUNABannerViewExtensionTest : XCTestCase
@property (nonatomic) RUNABannerViewGenreProperty *actual;
@end

@implementation RUNABannerViewExtensionTest
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

@end
