//
//  RUNAURLStringTests.m
//  CoreTests
//
//  Created by Sato, Akihiko | Akkie on 2021/06/30.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RUNACore/RUNAHttpTask.h>
#import "RUNAURLString.h"

@interface RUNAHttpTask (Spy)
@end

@implementation RUNAHttpTask (Spy)
- (NSURLSession *)httpSession {
    return self->_httpSession;
}
@end

@interface RUNAURLStringTests : XCTestCase
@end

@implementation RUNAURLStringTests

- (void)testStringExtension {
    {
        NSString *str1;
        XCTAssertEqualObjects(str1.getUrl, nil);
        NSString *str2 = @"value";
        XCTAssertEqualObjects(str2.getUrl, @"value");
    }
    {
        NSString<RUNAHttpTaskDelegate> *str = @"request";
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"url"]];
        XCTAssertNoThrow([str processConfig:request]);
    }
    {
        RUNAURLStringRequest *request = [[RUNAURLStringRequest alloc]init];
        XCTAssertNotNil(request.httpSession);
    }
}

@end
