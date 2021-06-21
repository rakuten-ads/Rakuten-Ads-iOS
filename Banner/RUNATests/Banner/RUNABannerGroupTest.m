//
//  RUNABannerGroupTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/21.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNABannerGroup.h"
#import "RUNABannerViewInner.h"

@interface RUNABannerGroup (Spy)
@property (nonatomic, readonly) RUNABannerViewState state;
- (instancetype)init;
@end

@interface RUNABannerGroupTest : XCTestCase

@end

@implementation RUNABannerGroupTest

- (void)testInit {
    RUNABannerGroup *group = [[RUNABannerGroup alloc]init];
    XCTAssertEqual(group.state, RUNA_ADVIEW_STATE_INIT);
}

@end
