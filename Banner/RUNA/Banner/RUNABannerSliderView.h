//
//  RUNABannerSliderView.h
//  Banner
//
//  Created by Wu, Wei | David on 2021/09/03.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNABannerSliderView : UIView

@property(nonatomic, copy, nonnull) NSArray<NSString*>* adspotIds;

-(void) load;
-(void) loadWithEventHandler:(nullable void (^)(RUNABannerSliderView* view, struct RUNABannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END
