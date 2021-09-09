//
//  RUNABannerSliderView.m
//  Banner
//
//  Created by Wu, Wei | David on 2021/09/03.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNABannerSliderExtension.h"
#import "RUNABannerGroupInner.h"

@interface RUNABannerSliderView() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, nonnull) UICollectionView* collectionView;
@property (nonatomic, nonnull) NSMutableArray* loadedBanners;
@property (nonatomic, nonnull) RUNABannerGroup* group;

@end

@implementation RUNABannerSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.enableIndicator = NO;
        self.horizontalRatio = 1;
        self.group = [RUNABannerGroup new];
        self.loadedBanners = [NSMutableArray array];
    }
    return self;
}

-(void) load {
    [self loadWithEventHandler:nil];
}

-(void) loadWithEventHandler:(nullable void (^)(RUNABannerSliderView* view, struct RUNABannerViewEvent event)) handler {
    if (!self.adspotIds || self.adspotIds.count == 0) {
        NSLog(@"adspotIds must not be empty");
        return;
    }

    [self configCollectionView];

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

#pragma  mark - UI configuration
-(void) configCollectionView {
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];

    [self addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
}


#pragma mark UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width * self.horizontalRatio, collectionView.bounds.size.height);
}

#pragma mark UICollectionViewDelegate
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView addSubview:self.loadedBanners[indexPath.row]];
    return cell;
}

#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.loadedBanners.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
@end
