//
//  RUNABannerSliderView.h
//  Banner
//
//  Created by Wu, Wei | David on 2021/09/03.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RUNABannerView.h"
#import "RUNABannerViewExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNABannerSliderViewItem : NSObject <NSCopying>

@property(nonatomic, copy) NSString* adspotId;
@property(nonatomic, copy, nullable) RUNABannerViewGenreProperty* matchingGenre;
@property(nonatomic, copy, nullable) NSDictionary* target;

@end


@interface RUNABannerSliderView : UIView

@property(nonatomic, copy, nullable) NSArray<NSString*>* adspotIds;
@property(nonatomic, copy, nullable) NSArray<RUNABannerSliderViewItem*>* items;

@property(nonatomic) CGFloat spacing;
@property(nonatomic) CGFloat paddingHorizontal;
@property(nonatomic) CGFloat minItemPeekWidth;

-(void) load;
-(void) loadWithEventHandler:(nullable void (^)(RUNABannerSliderView* view, struct RUNABannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END
