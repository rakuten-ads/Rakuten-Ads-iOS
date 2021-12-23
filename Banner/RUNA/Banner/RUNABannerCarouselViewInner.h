//
//  RUNABannerCarouselViewInner.h
//  Banner
//
//  Created by Wu, Wei | David on 2021/11/09.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#ifndef RUNABannerCarouselViewInner_h
#define RUNABannerCarouselViewInner_h

#ifndef RUNABannerCarouselView_h
#import "RUNABannerCarouselView.h"
#endif

#import "RUNABannerGroupInner.h"

@interface RUNABannerCarouselView()

@property(nonatomic, nonnull) RUNABannerGroup* group;

@end

@interface RUNABannerCarouselItemViewCell : UICollectionViewCell

@property(nonatomic, weak, nullable) UICollectionView* collectionView;
@property(nonatomic) CGFloat adjustWidth;
@property(nonatomic, readonly, nonnull) NSLayoutConstraint* widthConstraint;

-(void) config:(UICollectionView*) collectionView withAdjustWidth:(CGFloat) adjustWidth;

@end

#endif /* RUNABannerCarouselViewInner_h */
