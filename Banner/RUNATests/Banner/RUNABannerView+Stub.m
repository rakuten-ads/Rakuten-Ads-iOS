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
    NSString *html = [NSString stringWithFormat:@"<script type=\"text/javascript\">window.onload = function() {window.webkit.messageHandlers.runaSdkInterface.postMessage({\"type\":\"%@\"});}</script>", type];
    return @{@"adm": html};
}

@end
