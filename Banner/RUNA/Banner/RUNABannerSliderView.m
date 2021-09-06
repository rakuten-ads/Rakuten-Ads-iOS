//
//  RUNABannerSliderView.m
//  Banner
//
//  Created by Wu, Wei | David on 2021/09/03.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNABannerSliderView.h"
#import "RUNABannerGroupInner.h"

@interface RUNABannerSliderView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, nonnull) UICollectionView* collectionView;
@property (nonatomic, nonnull) NSMutableArray* loadedBanners;
@property (nonatomic, nonnull) RUNABannerGroup* group;

@end

@implementation RUNABannerSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.group = [RUNABannerGroup new];
        self.collectionView = [UICollectionView new];
    }
    return self;
}

-(void) load {
    [self loadWithEventHandler:nil];
}

-(void) loadWithEventHandler:(nullable void (^)(RUNABannerSliderView* view, struct RUNABannerViewEvent event)) handler {
    if (!self.adspotIds || self.adspotIds.count == 0) {
        NSLog(@"adspotIds must not be empty");
    }

    NSMutableArray<RUNABannerView*>* banners = [NSMutableArray array];
    [self.adspotIds enumerateObjectsUsingBlock:^(NSString * _Nonnull adspotId, NSUInteger idx, BOOL * _Nonnull stop) {
        RUNABannerView* banner = [RUNABannerView new];
        banner.adSpotId = adspotId;
        banner.size = RUNABannerViewSizeAspectFit;
        [banners addObject:banner];
    }];
    self.group.banners = banners;

    [self.group loadWithEventHandler:^(RUNABannerGroup * _Nonnull group, RUNABannerView * _Nullable banner, struct RUNABannerViewEvent event) {

        switch (event.eventType) {
            case RUNABannerViewEventTypeGroupFinished:
                // TODO banners order
                [self.collectionView reloadData];
                break;
            case RUNABannerViewEventTypeSucceeded:
                [self.loadedBanners addObject:banner];
            default:
                break;
        }

        if (handler) {
            handler(self, event);
        }
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.loadedBanners.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView addSubview:self.loadedBanners[indexPath.row]];
    return cell;
}

@end
