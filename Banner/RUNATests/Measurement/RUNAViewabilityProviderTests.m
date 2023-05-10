//
//  RUNAViewabilityProviderTests.m
//  BannerTests
//
//  Created by Wu, Wei | David on 2022/02/16.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNAViewabilityProvider.h"
#import "RUNAMeasurement.h"

@interface RUNAViewabilityTarget : NSObject<RUNADefaultMeasurement, RUNAMeasurerDelegate>

@property(nonatomic, readonly) NSString* identifier;
@property(nonatomic, weak) UIView* view;
@property(nonatomic, copy, nullable) NSString* viewImpURL;
@property(nonatomic, copy, nullable) RUNAViewabilityCompletionHandler completionHandler;
@property(nonatomic, readonly) id<RUNAMeasurer> measurer;

-(float)getVisibility:(UIWindow *)window
   rootViewController:(UIViewController *)rootViewController;
-(BOOL)isVisible:(float)visibility;

@end

@interface RUNAViewabilityProvider(Tests)

@property(nonatomic) NSMutableDictionary<NSString*, RUNAViewabilityTarget*>* targetDict;

@end


@interface RUNAViewabilityProviderTests : XCTestCase

@end

@implementation RUNAViewabilityProviderTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testTargetViewInvisible {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    RUNAViewabilityProvider* provider = [RUNAViewabilityProvider sharedInstance];

    // register nil
    [provider registerTargetView:nil withViewImpURL:nil completionHandler:nil];
    XCTAssertEqual(provider.targetDict.count, 0);

    // register a view
    UIView* targetView = [UIView new];
    [provider registerTargetView:targetView withViewImpURL:nil completionHandler:nil];

    XCTAssertEqual(provider.targetDict.count, 1);
    NSString* key = [NSString stringWithFormat:@"%lu", (unsigned long)targetView.hash];
    RUNAViewabilityTarget* target = provider.targetDict[key];
    XCTAssertNotNil(target);
    XCTAssertTrue([key isEqualToString:target.identifier]);
    XCTAssertEqual(target.view, targetView);
    XCTAssertNil(target.viewImpURL);
    XCTAssertNil(target.completionHandler);
    XCTAssertTrue([target.measurer isKindOfClass:[RUNADefaultMeasurer class]]);

    // unregister nil
    XCTAssertNoThrow([provider unregisterTargetView:nil]);

    // unregister view
    XCTAssertNoThrow([provider unregisterTargetView:targetView]);
    XCTAssertNil([provider.targetDict valueForKey:key]);
}

-(void)testTargetViewVisible {

    RUNAViewabilityProvider* provider = [RUNAViewabilityProvider sharedInstance];

    UIView* targetView = [UIView new];
    [provider registerTargetView:targetView withViewImpURL:@"https://www.rakuten.com" completionHandler:^(UIView * _Nonnull view) {
        NSLog(@"view visible");
    }];

    XCTAssertEqual(provider.targetDict.count, 1);
    NSString* key = [NSString stringWithFormat:@"%lu", (unsigned long)targetView.hash];
    RUNAViewabilityTarget* target = provider.targetDict[key];
    XCTAssertNotNil(target);

    XCTAssertNotNil(target.measurer);
    XCTAssertFalse([target measureInview]);
    XCTAssertTrue([target didMeasureInview:YES]);
    XCTAssertFalse([target didMeasureInview:NO]);

    XCTAssertTrue([target getVisibility:[UIWindow new] rootViewController:[UIViewController new]] == 0);
    XCTAssertTrue([target isVisible:0.6]);
    XCTAssertFalse([target isVisible:0.5]);

    XCTAssertNoThrow([provider unregsiterTargetView:targetView]);
    XCTAssertNil([provider.targetDict valueForKey:key]);

}
@end
