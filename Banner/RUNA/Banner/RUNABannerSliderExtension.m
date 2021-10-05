//
//  RUNABannerSliderView.m
//  Banner
//
//  Created by Wu, Wei | David on 2021/09/03.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNABannerSliderExtension.h"
#import "RUNABannerGroupInner.h"
#import "RUNABannerViewInner.h"

@interface RUNABannerSliderView() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, nonnull) UICollectionView* collectionView;
@property (nonatomic, nullable) UIPageControl* pageCtrl;
@property (nonatomic) CGFloat maxAspectRatio;
@property (nonatomic, nullable) NSArray<NSLayoutConstraint*>* sizeConstraints;

@property (nonatomic, nonnull) NSMutableArray* loadedBanners;
@property (nonatomic, nonnull) RUNABannerGroup* group;

@end

@implementation RUNABannerSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.indicatorEnabled = NO;
//        self.horizontalRatio = 1.0;
        self.horizantalMargin = 0.0;
        self.spacing = 0.0;
        self.maxAspectRatio = 0.0;
        self.contentScale = RUNABannerSliderViewScaleNone;

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
        NSLog(@"[banner slider] adspotIds must not be empty");
        return;
    }

    NSMutableArray<RUNABannerView*>* banners = [NSMutableArray array];
    [self.adspotIds enumerateObjectsUsingBlock:^(NSString * _Nonnull adspotId, NSUInteger idx, BOOL * _Nonnull stop) {
        RUNABannerView* banner = [RUNABannerView new];
        banner.adSpotId = adspotId;
        banner.position = RUNABannerViewPositionTopLeft;
        banner.size = RUNABannerViewSizeAspectFit;
        [banners addObject:banner];
    }];
    self.group.banners = banners;

    [self.group loadWithEventHandler:^(RUNABannerGroup * _Nonnull group, RUNABannerView * _Nullable banner, struct RUNABannerViewEvent event) {

        switch (event.eventType) {
            case RUNABannerViewEventTypeGroupFinished:
                [self configCollectionView];
                [self configIndicator];
                [self applyContainerSize];
                [self.collectionView reloadData];
                break;
            case RUNABannerViewEventTypeSucceeded:
                [self updateMaxSize:banner];
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
    RUNADebug("[banner slider] configCollectionView");
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = self.spacing;
    layout.minimumLineSpacing = 0.0;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];

    [self addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
}

-(void) updateMaxSize: (RUNABannerView*) bannerView {
    RUNABanner* bannerInfo = bannerView.banner;
    self.maxAspectRatio = MAX(self.maxAspectRatio, bannerInfo.height / bannerInfo.width);
}

-(void) applyContainerSize {
    if (self.superview && self.collectionView && self.group.state == RUNABannerViewEventTypeGroupFinished) {
        RUNADebug("[banner slider] apply size");
        [self.superview removeConstraints:self.sizeConstraints];
        [self removeConstraints:self.sizeConstraints];

        switch (self.contentScale) {
            case RUNABannerSliderViewScaleAspectStretch:
                if (@available(ios 11.0, *)) {
                    UILayoutGuide* safeGuide = self.superview.safeAreaLayoutGuide;
                    self->_sizeConstraints = @[[self.widthAnchor constraintEqualToAnchor:safeGuide.widthAnchor],
                                               [self.heightAnchor constraintEqualToAnchor:safeGuide.widthAnchor multiplier:self.maxAspectRatio],
                    ];
                } else {
                    self->_sizeConstraints = @[[self.widthAnchor constraintEqualToAnchor:self.superview.widthAnchor],
                                               [self.heightAnchor constraintEqualToAnchor:self.superview.widthAnchor multiplier:self.maxAspectRatio],
                    ];
                }
                self.translatesAutoresizingMaskIntoConstraints = NO;
                [self.superview addConstraints:self.sizeConstraints];
                break;
            case RUNABannerSliderViewScaleAspectFit:
                if (@available(ios 11.0, *)) {
                    UILayoutGuide* safeGuide = self.superview.safeAreaLayoutGuide;
                    NSLayoutConstraint* aspectConstraint = [self.heightAnchor constraintEqualToAnchor:self.widthAnchor multiplier:self.maxAspectRatio];
                    aspectConstraint.priority = UILayoutPriorityDefaultHigh;
                    self->_sizeConstraints = @[[self.widthAnchor constraintLessThanOrEqualToAnchor:safeGuide.widthAnchor],
                                               [self.heightAnchor constraintLessThanOrEqualToAnchor:safeGuide.heightAnchor],
                                               aspectConstraint,
                    ];
                } else {
                    NSLayoutConstraint* aspectConstraint = [self.heightAnchor constraintEqualToAnchor:self.widthAnchor multiplier:self.maxAspectRatio];
                    aspectConstraint.priority = UILayoutPriorityDefaultHigh;
                    self->_sizeConstraints = @[[self.widthAnchor constraintLessThanOrEqualToAnchor:self.superview.widthAnchor],
                                               [self.heightAnchor constraintLessThanOrEqualToAnchor:self.superview.heightAnchor],
                                               aspectConstraint,
                    ];
                }
                self.translatesAutoresizingMaskIntoConstraints = NO;
                [self.superview addConstraints:self.sizeConstraints];
                break;

            default:
                self.sizeConstraints = nil;
                break;
        }
    }
}

-(void) configIndicator {
    if (self.indicatorEnabled && self.loadedBanners.count > 0) {
        RUNADebug("[banner slider] configIndicator");

        UIPageControl* pageCtrl = [UIPageControl new];
        pageCtrl.numberOfPages = self.loadedBanners.count;
        pageCtrl.currentPage = 0;
        pageCtrl.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:pageCtrl];
        [self addConstraints:@[
            [pageCtrl.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [pageCtrl.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:4.0],
        ]];
        self.pageCtrl = pageCtrl;
    }
}

-(void)didMoveToSuperview {
    RUNADebug("[banner slider] didMoveToSuperview");
    if (self.superview) {
        [self applyContainerSize];
        [self layoutIfNeeded];
    } else {
        RUNADebug("[banner slider] removeFromSuperview leads here when superview is nil");
    }
}

-(void)removeFromSuperview {
    RUNADebug("[banner slider] removeFromSuperview");
    [super removeFromSuperview];
}

#pragma mark UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize cellSize = CGSizeMake(collectionView.bounds.size.width - self.horizantalMargin * 2.0, collectionView.bounds.size.height);
    RUNADebug("[banner slider] cell size %@ for index %ld", NSStringFromCGSize(cellSize), (long)indexPath.row);
    return cellSize;
}

#pragma mark UICollectionViewDelegate
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [cell.contentView addSubview:self.loadedBanners[indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.pageCtrl.currentPage = indexPath.item;
}

#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.loadedBanners.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
@end
