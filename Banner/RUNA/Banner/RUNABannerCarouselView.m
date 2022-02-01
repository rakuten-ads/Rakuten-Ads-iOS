//
//  RUNABannerCarouselView.m
//  Banner
//
//  Created by Wu, Wei | David on 2021/09/03.
//  Copyright © 2021 Rakuten MPD. All rights reserved.
//

#import "RUNABannerCarouselViewInner.h"
#import "RUNABannerGroupInner.h"
#import "RUNABannerGroupExtension.h"
#import "RUNABannerViewInner.h"

@interface RUNABannerCarouselView() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic) BOOL indicatorEnabled;
@property(nonatomic, nonnull) UICollectionView* collectionView;
@property(nonatomic, nullable) UIPageControl* pageCtrl;
@property(nonatomic) CGFloat maxAspectRatio;
@property(nonatomic, nullable) NSLayoutConstraint* widthConstraint;
@property(nonatomic, nullable) NSLayoutConstraint* heightConstraint;
@property(nonatomic) CGFloat maxContentHeight;

@property(nonatomic, nonnull) NSMutableArray* loadedBanners;

@end

@implementation RUNABannerCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.indicatorEnabled = NO;
        self.contentEdgeInsets = UIEdgeInsetsZero;
        self.itemEdgeInsets = UIEdgeInsetsZero;
        self.itemSpacing = 0.0;
        self.maxAspectRatio = 0.0;
        self.maxContentHeight = 0.0;
        self.group = [RUNABannerGroup new];
        self.loadedBanners = [NSMutableArray array];
    }
    return self;
}

-(NSInteger)itemCount {
    return self.loadedBanners.count;
}

-(void) load {
    [self loadWithEventHandler:nil];
}

-(void) loadWithEventHandler:(nullable void (^)(RUNABannerCarouselView* _Nonnull view, RUNABannerView * _Nullable banner, struct RUNABannerViewEvent event)) handler {
    if ((!self.adSpotIds || self.adSpotIds.count == 0)
        && (!self.itemViews || self.itemViews.count == 0)) {
        NSLog(@"[banner slider] adspotIds or items must not be empty");
        return;
    }

    if (self.itemViews && self.itemViews.count > 0) {
        NSMutableArray<NSString*>* adspotIdList = [NSMutableArray array];
        [self.itemViews enumerateObjectsUsingBlock:^(RUNABannerView * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            item.size = RUNABannerViewSizeAspectFit;
            [adspotIdList addObject:item.adSpotId];
        }];
        self.adSpotIds = adspotIdList;
        self.group.banners = self.itemViews;
    } else {
        NSMutableArray<RUNABannerView*>* banners = [NSMutableArray array];
        [self.adSpotIds enumerateObjectsUsingBlock:^(NSString * _Nonnull adspotId, NSUInteger idx, BOOL * _Nonnull stop) {
            RUNABannerView* banner = [RUNABannerView new];
            banner.adSpotId = adspotId;
            banner.size = RUNABannerViewSizeAspectFit;
            [banners addObject:banner];
        }];
        self.group.banners = banners;
    }

    __weak typeof(self) weakSelf = self;
    [self.group loadWithEventHandler:^(RUNABannerGroup * _Nonnull group, RUNABannerView * _Nullable banner, struct RUNABannerViewEvent event) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        switch (event.eventType) {
            case RUNABannerViewEventTypeGroupFinished:
                [strongSelf configCollectionView];
                [strongSelf configIndicator];
                [strongSelf applyContainerSize];
                [strongSelf.collectionView reloadData];
                [strongSelf layoutIfNeeded];
                if (handler) {
                    handler(strongSelf, nil, event);
                }
                break;
            case RUNABannerViewEventTypeGroupFailed:
                RUNALog("RUNABannerViewEventTypeGroupFailed");
                if (handler) {
                    handler(strongSelf, nil, event);
                }
                break;
            case RUNABannerViewEventTypeSucceeded:
                [strongSelf updateMaxAspectRatio:banner];
                [strongSelf.loadedBanners addObject:banner];
                // fallthrough to default
            default:
                if (handler) {
                    handler(strongSelf, banner, event);
                }
                break;
        }
    }];
}

#pragma  mark - UI configuration
-(void) configCollectionView {
    RUNADebug("[banner slider] configCollectionView");
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = self.itemSpacing;
    layout.minimumInteritemSpacing = 0.0;
    layout.sectionInset = UIEdgeInsetsMake(0, self.contentEdgeInsets.left, 0, self.contentEdgeInsets.right);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = self.indicatorEnabled;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:RUNABannerCarouselItemViewCell.class forCellWithReuseIdentifier:@"cell"];

    [self addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor constant:self.contentEdgeInsets.top],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-self.contentEdgeInsets.bottom],
    ]];
}

-(void) updateMaxAspectRatio: (RUNABannerView*) bannerView {
    RUNABanner* bannerInfo = bannerView.banner;
    self.maxAspectRatio = MAX(self.maxAspectRatio, bannerInfo.height / bannerInfo.width);
}

-(void) applyContainerSize {
    if (self.superview && self.collectionView && self.group.state == RUNA_ADVIEW_STATE_SHOWED) {
        RUNADebug("[banner slider] apply size");
        [self.superview removeConstraint:self.widthConstraint];
        [self removeConstraint:self.heightConstraint];

        if (@available(ios 11.0, *)) {
            UILayoutGuide* safeGuide = self.superview.safeAreaLayoutGuide;
            self.widthConstraint = [self.widthAnchor constraintEqualToAnchor:safeGuide.widthAnchor];
        } else {
            self.widthConstraint = [self.widthAnchor constraintEqualToAnchor:self.superview.widthAnchor];
        }
        if (self.maxContentHeight > 0) {
            self.heightConstraint = [self.heightAnchor constraintEqualToConstant:self.maxContentHeight];
        } else {
            CGFloat kInitialContentHeight = UIScreen.mainScreen.bounds.size.width * self.maxAspectRatio + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
            RUNADebug("[banner slider] initial height %lf", kInitialContentHeight);
            self.heightConstraint = [self.heightAnchor constraintEqualToConstant:kInitialContentHeight];
        }
        self.heightConstraint.priority = UILayoutPriorityDefaultHigh;

        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self.superview addConstraint:self.widthConstraint];
        [self addConstraint:self.heightConstraint];
    }
}

-(void) configIndicator {
    if (self.indicatorEnabled && self.loadedBanners.count > 0) {
        RUNADebug("[banner slider] configIndicator");

        UIPageControl* pageCtrl = [UIPageControl new];
        pageCtrl.numberOfPages = self.loadedBanners.count;
        pageCtrl.currentPage = 0;
        pageCtrl.translatesAutoresizingMaskIntoConstraints = NO;
        pageCtrl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:pageCtrl];
        [self addConstraints:@[
            [pageCtrl.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [pageCtrl.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5.0],
        ]];
        self.pageCtrl = pageCtrl;
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    RUNADebug("[banner slider] carousel view layoutSubviews");
    if (self.collectionView) {
        CGFloat contentHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
        if (contentHeight > 0 && self.heightConstraint.constant != contentHeight) {
            RUNADebug("[banner slider] carousel view height updated to %f", contentHeight);
            [self.heightConstraint setConstant:contentHeight];
        }
    }
}

-(void)layoutMarginsDidChange {
    [super layoutMarginsDidChange];

    RUNADebug("[banner slider] carousel view layoutMarginsDidChange");
    if (self.collectionView) {
        CGFloat contentHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
        if (contentHeight && self.heightConstraint.constant != contentHeight) {
            RUNADebug("[banner slider] carousel view height updated to %f", contentHeight);
            [self.heightConstraint setConstant:contentHeight];
        }
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

#pragma mark - UICollectionViewDataSource
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RUNADebug("[banner slider] cellForItemAtIndexPath row=%ld", indexPath.item);
    RUNABannerCarouselItemViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell config:self];

    RUNABannerView* banner = self.loadedBanners[indexPath.item];

    UIView* bannerContainerView;
    if (self.decorator) {
        bannerContainerView = self.decorator(banner, indexPath.item);
        RUNADebug("[banner slider] decorated cell(%ld)", indexPath.item);
    } else if (!UIEdgeInsetsEqualToEdgeInsets(self.itemEdgeInsets, UIEdgeInsetsZero)) {
        UIView* marginView = [UIView new];
        marginView.translatesAutoresizingMaskIntoConstraints = NO;
        [marginView addSubview:banner];
        [NSLayoutConstraint activateConstraints:@[
            [banner.leadingAnchor constraintEqualToAnchor:marginView.leadingAnchor],
            [banner.topAnchor constraintEqualToAnchor:marginView.topAnchor],
            [banner.trailingAnchor constraintEqualToAnchor:marginView.trailingAnchor],
            [banner.bottomAnchor constraintEqualToAnchor:marginView.bottomAnchor],
        ]];

        bannerContainerView = [UIView new];
        bannerContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        bannerContainerView.layoutMargins = self.itemEdgeInsets;
        [bannerContainerView addSubview:marginView];

        [NSLayoutConstraint activateConstraints:@[
            [marginView.leadingAnchor constraintEqualToAnchor:bannerContainerView.layoutMarginsGuide.leadingAnchor],
            [marginView.topAnchor constraintEqualToAnchor:bannerContainerView.layoutMarginsGuide.topAnchor],
            [marginView.trailingAnchor constraintEqualToAnchor:bannerContainerView.layoutMarginsGuide.trailingAnchor],
            [marginView.bottomAnchor constraintEqualToAnchor:bannerContainerView.layoutMarginsGuide.bottomAnchor],
        ]];
        RUNADebug("[banner slider] item cell(%ld) with edges", indexPath.item);
    } else {
        bannerContainerView = banner;
        RUNADebug("[banner slider] default item cell(%ld)", indexPath.item);
    }

    [cell.contentView addSubview:bannerContainerView];

    [NSLayoutConstraint activateConstraints:@[
        [bannerContainerView.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor],
        [bannerContainerView.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor],
        [bannerContainerView.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor],
        [bannerContainerView.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor],
    ]];

    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.loadedBanners.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    RUNADebug("[banner slider] didEndDisplayingCell index %ld", indexPath.item);
    self.pageCtrl.currentPage = indexPath.item;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RUNADebug("[banner slider] sizeForItem index %ld", indexPath.item);
    CGFloat cellWidth = 0;
    switch (self.itemScaleMode) {
        case RUNABannerCarouselViewItemScaleAspectFit:
            if (self.collectionView) {
                CGFloat adjustWidth =
                    - self.contentEdgeInsets.left
                    - self.itemSpacing
                    - MAX(self.contentEdgeInsets.right,
                          self.itemCount > 1 ? self.minItemOverhangWidth : 0);
                cellWidth = self.collectionView.bounds.size.width + adjustWidth;
            }
            break;
        case RUNABannerCarouselViewItemScaleFixedWidth:
            cellWidth = self.itemWidth;
            break;
        default:
            break;
    }

    CGFloat cellHeight = 0.0;
    cellHeight = (cellWidth - self.itemEdgeInsets.left - self.itemEdgeInsets.right) * self.maxAspectRatio + self.itemEdgeInsets.top + self.itemEdgeInsets.bottom;

    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - assistance

-(NSDictionary *) descriptionDetail {
    return @{
        @"adspotIds" : self.adSpotIds ?: NSNull.null,
        @"itemScaleMode" : self.itemScaleMode == RUNABannerCarouselViewItemScaleAspectFit ? @"aspectFit" : @"fixedWidth",
        @"contentEdge" : @(self.contentEdgeInsets),
        @"itemSpacing" : @(self.itemSpacing),
        @"minItemOverhangWidth" : @(self.minItemOverhangWidth),
        @"itemEdge" : @(self.itemEdgeInsets),
        @"itemWidth" : @(self.itemWidth),
        @"itemCount" : @(self.itemCount)
    };
}

-(NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@", self.descriptionDetail];
}

@end


@implementation RUNABannerCarouselItemViewCell

-(void)prepareForReuse {
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];

    [super prepareForReuse];
}

-(void) config:(RUNABannerCarouselView*) carouselView {
    self.carouselView = carouselView;
    self.backgroundColor = UIColor.clearColor;
}

@end
