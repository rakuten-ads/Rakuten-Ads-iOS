//
//  RUNAUIView+.m
//  Core
//
//  Created by Wu, Wei | David | GATD on 2023/06/05.
//  Copyright © 2023 Rakuten MPD. All rights reserved.
//

#import "RUNAUIView+.h"

@implementation UIView(RUNA_UIKit)

-(NSString*) runaViewIdentifier {
    return [NSString stringWithFormat:@"%lu", (unsigned long)self.hash];
}
@end
