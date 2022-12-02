//
//  RUNABannerUtility.m
//  BannerTests
//
//  Created by Wu, Wei | David | GATD on 2022/12/02.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RUNABannerUtil.h"

@interface RUNABannerUtilityTests : XCTestCase

@end

@implementation RUNABannerUtilityTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testNormalize {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSArray<NSString*>* inputs = @[
        @"　ﾅｲｷ nike　ｷﾞﾌﾄ　ナイキ     シューズ    ",
        @"nike air",
        @"NIkE AIR",
        @" 漢    字＂/　/ｱ/ｲ/ｳ/ｴ/ｵ/ｶ/ｷ/ｸ/ｹ/ｺ/ｻ/ｼ/ｽ/ｾ/ｿ/ﾀ/ﾁ/ﾂ/ﾃ/ﾄ/ﾅ/ﾆ/ﾇ/ﾈ/ﾉ/ﾊ/ﾋ/ﾌ/ﾍ/ﾎ/ﾏ/ﾐ/ﾑ/ﾒ/ﾓ/ﾔ/ﾕ/ﾖ/ﾗ/ﾘ/ﾙ/ﾚ/ﾛ/ﾜ/ｦ/ﾝ/ｯ/ｧ/ｨ/ｩ/ｪ/ｫ/ｬ/ｭ/ｮ/ﾞ/ﾟ/ｰ/･/：/；/＆/－/／/？/！/０/１/２/３/４/５/６/７/８/９/Ａ/Ｂ/Ｃ/Ｄ/Ｅ/Ｆ/Ｇ/Ｈ/Ｉ/Ｊ/Ｋ/Ｌ/Ｍ/Ｎ/Ｏ/Ｐ/Ｑ/Ｒ/Ｓ/Ｔ/Ｕ/Ｖ/Ｗ/Ｘ/Ｙ/Ｚ/ａ/ｂ/ｃ/ｄ/ｅ/ｆ/ｇ/ｈ/ｉ/ｊ/ｋ/ｌ/ｍ/ｎ/ｏ/ｐ/ｑ/ｒ/ｓ/ｔ/ｕ/ｖ/ｗ/ｘ/ｙ/ｚ",
    ];
    NSArray<NSString*>* expectResults = @[
        @"ナイキ nike ギフト ナイキ シューズ",
        @"nike air",
        @"nike air",
        @"漢 字\"/ /ア/イ/ウ/エ/オ/カ/キ/ク/ケ/コ/サ/シ/ス/セ/ソ/タ/チ/ツ/テ/ト/ナ/ニ/ヌ/ネ/ノ/ハ/ヒ/フ/ヘ/ホ/マ/ミ/ム/メ/モ/ヤ/ユ/ヨ/ラ/リ/ル/レ/ロ/ワ/ヲ/ン/ッ/ァ/ィ/ゥ/ェ/ォ/ャ/ュ/ョ/゙/゚/ー/・/:/;/&/-///?/!/0/1/2/3/4/5/6/7/8/9/a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p/q/r/s/t/u/v/w/x/y/z/a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p/q/r/s/t/u/v/w/x/y/z",
    ];

    [inputs enumerateObjectsUsingBlock:^(NSString * _Nonnull input, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* result = [RUNABannerUtil normalize:input];
        XCTAssertEqualObjects(expectResults[idx], result);
    }];
}

@end
