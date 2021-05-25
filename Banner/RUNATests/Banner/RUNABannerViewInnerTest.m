//
//  RUNABannerViewInnerTest.m
//  BannerTests
//
//  Created by Sato, Akihiko | Akkie on 2021/05/25.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "RUNABanner.h"
#import "RUNABannerView+Stub.h"
#import "RUNABannerViewInner.h"

@interface RUNABanner (Spy)
@property(nonatomic) NSString *html;
@end

@interface RUNABannerView (Spy)
@property (nonatomic) RUNABanner *banner;
- (void)applyAdView;
@end

@interface RUNABannerViewInnerTest : XCTestCase
@property (nonatomic) RUNABannerView *bannerView;
@end

@implementation RUNABannerViewInnerTest
@synthesize bannerView = _bannerView;

- (void)setUp {
    NSDictionary *stb = @{@"h":@780L, @"w":@1280L};
    self.bannerView = [[RUNABannerView alloc]initWithBidResponse:stb];
}
//
//- (void)tearDown {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    self.bannerView.openMeasurementDisabled = YES;
    self.bannerView.banner.html = @"<div id=\"rdn-ad-3802065325978514222\" class=\"rdn-ad-main-content\"></div>\n<script>window.rdncd = {\"src\": \"https://dev-s-dlv.rmp.rakuten.co.jp/cd?dat=AajbOqvDn2lRHuyHaiYZNidGMD_YEUgOr97Pc-Z3mGS2fM-hgj2fqqkNxeztHUcHSWNzzWUAf6Ymg-Gjc8VHZoUCmF_SrIzNU5gtRs4ClrA2AESh_Uh_owaZC8rZtIGOSvjL1la6UXJvvyI-RF4NYLy2cPLlJOwIYGHzWczr-uoTH1fzs3KzG873H61xqbh_s-m2AH8-tCJDNdB4q77TxxktJ_PtXoFHs2HA0NZRiFC5CDMGBX2RHmrweXuf3-LOnCv3UsZUSZks604nQ3EEiQlhwD5AyhQwBpzBOw2xZxI8PDY4FIirOXJXHDAOjsUpMvNw5hM2MrYrI_o_FtmhLR6pVyajszBc0uVcOMa4FbVMiAtqpqsZP4whFHwWr50HJf5U-0Pk1wLLgcVCm5327tqLVAbHLdlp535FkbveZObeClDUxMAo_oTBXDU8DjBs_4atLRY_lO6fnzGnqSltgy5d2MgfxcuuonSdwY0WbIVByB3IG7MmGdKJXw185G3ZPWnF2oMpzONybAMUb3drp081SMDmxPxBNbCY3iYuBgLlA2Cylbc23oV-wc7WnXt4D-dVpiUjmBG75zfgbrE6JmSzjkDOzYcfzPYuPajy4TnlCgEallP7OFkalSSoxYO861-a1DwvSvqhCm_VPDyCE-H-FxjwgkrHl1x3ok1msb1lszVgFc7naRU18JAlA72h5n9xRRsSsas9dNUHgSsZTsAb3DNeOyt2aro9Qdf0NJUuZa5Nc3KYS_RUKVAUXlYmgcx54LAguzCHnF_XgjHGX4crAQSKxOG2u9wUKb1jZh-xOXSIDsfSD0418RTAJm8iXy3Is1amKUjFWfy4Dja_UmGZ0A-SFcyqh55Y9VQ3WuKD";
    [self.bannerView applyAdView];
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
