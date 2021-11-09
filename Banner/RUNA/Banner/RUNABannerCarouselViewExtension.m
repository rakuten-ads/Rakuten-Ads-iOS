//
//  RUNABannerCarouselViewExtension.m
//  Banner
//
//  Created by Wu, Wei | David on 2021/11/09.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNABannerCarouselViewExtension.h"
#import "RUNABannerCarouselViewInner.h"
#import "RUNABannerGroupExtension.h"

@implementation RUNABannerCarouselView(RUNA_Extension)

-(void)setRz:(NSString *)rz {
    [self.group setRz:rz];
}

@end
