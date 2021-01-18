//
//  RUNAAdSession.m
//  Banner
//
//  Created by Wu, Wei | David on 2021/01/13.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNAAdSessionInner.h"

@implementation RUNAAdSession

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_uuid = [NSUUID UUID].UUIDString;
    }
    return self;
}

-(void)addBlockAd:(NSInteger)advId {
    if (!self.blockAdList) {
        self->_blockAdList = [NSMutableArray array];
    }
    [self.blockAdList addObject:[NSNumber numberWithInteger:advId]];
}

@end
