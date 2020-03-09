#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RUNABannerViewPosition) {
    RUNABannerViewPositionCustom,
    RUNABannerViewPositionTop,
    RUNABannerViewPositionBottom,
    RUNABannerViewPositionTopLeft,
    RUNABannerViewPositionTopRight,
    RUNABannerViewPositionBottomLeft,
    RUNABannerViewPositionBottomRight,
};

typedef NS_ENUM(NSUInteger, RUNABannerViewEvent) {
    RUNABannerViewEventSucceeded,
    RUNABannerViewEventFailed,
    RUNABannerViewEventClicked,
};

typedef NS_ENUM(NSUInteger, RUNABannerViewSize) {
    RUNABannerViewSizeDefault,
    RUNABannerViewSizeAspectFit,
    RUNABannerViewSizeCustom,
};

@interface RUNABannerView : UIView

@property(nonatomic, copy, nonnull) NSString* adSpotId;
@property(nonatomic) RUNABannerViewSize size;
@property(nonatomic) RUNABannerViewPosition position;
@property(nonatomic, nullable) NSDictionary* properties;

-(void) load;
-(void) loadWithEventHandler:(nullable void (^)(RUNABannerView* view, RUNABannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END
