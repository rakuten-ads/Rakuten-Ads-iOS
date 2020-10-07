#import <UIKit/UIKit.h>

#ifndef RUNABannerView_h
#define RUNABannerView_h

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

typedef NS_ENUM(NSUInteger, RUNABannerViewEventType) {
    RUNABannerViewEventTypeSucceeded,
    RUNABannerViewEventTypeFailed,
    RUNABannerViewEventTypeClicked,
};

typedef NS_ENUM(NSUInteger, RUNABannerViewSize) {
    RUNABannerViewSizeDefault,
    RUNABannerViewSizeAspectFit,
    RUNABannerViewSizeCustom,
};

typedef NS_ENUM(NSUInteger, RUNABannerViewError) {
    RUNABannerViewErrorNone,
    RUNABannerViewErrorInternal,
    RUNABannerViewErrorNetwork,
    RUNABannerViewErrorFatal,
    RUNABannerViewErrorUnfilled,
};

struct RUNABannerViewEvent {
    RUNABannerViewEventType eventType;
    RUNABannerViewError error;
};

@interface RUNABannerView : UIView

@property(nonatomic, copy, nonnull) NSString* adSpotId;
@property(nonatomic) RUNABannerViewSize size;
@property(nonatomic) RUNABannerViewPosition position;
@property(nonatomic, nullable) NSDictionary* properties;

-(void) load;
-(void) loadWithEventHandler:(nullable void (^)(RUNABannerView* view, struct RUNABannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END

#endif
