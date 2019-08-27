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

@interface RPSBannerView : UIView

@property(nonatomic, copy, nonnull) NSString* adSpotId;

-(void) load;
-(void) loadWithEventHandler:(nullable void (^)(RPSBannerView* view, RPSBannerViewEvent event)) handler;
-(void) setPosition:(RPSBannerViewPosition)position inView:(UIView*) parentView;

@end

NS_ASSUME_NONNULL_END
