#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RPSBannerViewPosition) {
    RPSBannerViewPositionCustom,
    RPSBannerViewPositionTop,
    RPSBannerViewPositionBottom,
    RPSBannerViewPositionTopLeft,
    RPSBannerViewPositionTopRight,
    RPSBannerViewPositionBottomLeft,
    RPSBannerViewPositionBottomRight,
};

typedef NS_ENUM(NSUInteger, RPSBannerViewEvent) {
    RPSBannerViewEventSucceeded,
    RPSBannerViewEventFailed,
    RPSBannerViewEventClicked,
};

typedef NS_ENUM(NSUInteger, RPSBannerViewSize) {
    RPSBannerViewSizeDefault,
    RPSBannerViewSizeAspectFill,
};

@interface RPSBannerView : UIView

@property(nonatomic, copy, nonnull) NSString* adSpotId;
@property(nonatomic) RPSBannerViewSize size;
@property(nonatomic) RPSBannerViewPosition position;

-(void) load;
-(void) loadWithEventHandler:(nullable void (^)(RPSBannerView* view, RPSBannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END
