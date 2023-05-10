//
//  RUNAUIViewController+Tests.m
//  CoreTests
//
//  Created by Wu, Wei | David | GATD on 2023/04/09.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAUIViewController+.h"

@interface RUNAUIViewController_Tests : XCTestCase

@property(nonatomic) UIWindow* window;

@end

@implementation RUNAUIViewController_Tests

-(void)setUp {
    
}

-(void)tearDown {

}

- (void)testTopViewControllerInHierarchy {
    UIViewController* viewCtrlLayer1 = [UIViewController new];
    XCTAssertEqual([UIViewController topViewControllerInHierarchy:viewCtrlLayer1], viewCtrlLayer1);
}

@end
