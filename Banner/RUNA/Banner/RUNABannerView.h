#import <UIKit/UIKit.h>

#ifndef RUNABannerView_h
#define RUNABannerView_h

#import "RUNAAdSession.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 convenient options of position in autolayout
 */
typedef NS_ENUM(NSUInteger, RUNABannerViewPosition) {
    /// no layout constraints asign
    RUNABannerViewPositionCustom,
    /// top center layout constraints
    RUNABannerViewPositionTop,
    /// bottom center layout constraints
    RUNABannerViewPositionBottom,
    /// top left layout constraints
    RUNABannerViewPositionTopLeft,
    /// top right layout constraints
    RUNABannerViewPositionTopRight,
    /// bottom left layout constraints
    RUNABannerViewPositionBottomLeft,
    /// bottom right layout constraints
    RUNABannerViewPositionBottomRight,
};

/*!
 events when banner loading
 */
typedef NS_ENUM(NSUInteger, RUNABannerViewEventType) {
    /// banner load succeeded
    RUNABannerViewEventTypeSucceeded,
    /// banner load failed
    RUNABannerViewEventTypeFailed,
    /// banner clicked
    RUNABannerViewEventTypeClicked,
    /// RUNABannerGroup load failed
    RUNABannerViewEventTypeGroupFailed,
    /// RUNABannerGroup load finished, no matter parts are failed or succeeded
    RUNABannerViewEventTypeGroupFinished,
};

/*!
 options of size in autolayout
 */
typedef NS_ENUM(NSUInteger, RUNABannerViewSize) {
    /// asign the layout constraints of the size from admin site
    RUNABannerViewSizeDefault,
    /// asign the layout constraints to keep aspect radio and stretches its width to fit the super view's width
    RUNABannerViewSizeAspectFit,
    /// no layout constraints asign
    RUNABannerViewSizeCustom,
};

/*!
 error types for failure event
 */
typedef NS_ENUM(NSUInteger, RUNABannerViewError) {
    /// no error
    RUNABannerViewErrorNone,
    /// SDK internal error
    RUNABannerViewErrorInternal,
    /// error of the network connection
    RUNABannerViewErrorNetwork,
    /// error of illegal parameter settings
    RUNABannerViewErrorFatal,
    /// error of the ad is unfilled
    RUNABannerViewErrorUnfilled,
};

/*!
event detail declaration
 */
struct RUNABannerViewEvent {
    RUNABannerViewEventType eventType;
    RUNABannerViewError error;
};

/*!
 options of AdSpotBranchId
 */
typedef NS_ENUM(NSUInteger, RUNABannerAdSpotBranchId) {
    RUNABannerAdSpotBranchIdNone,
    RUNABannerAdSpotBranchId1,
    RUNABannerAdSpotBranchId2,
    RUNABannerAdSpotBranchId3,
    RUNABannerAdSpotBranchId4,
    RUNABannerAdSpotBranchId5,
    RUNABannerAdSpotBranchId6,
    RUNABannerAdSpotBranchId7,
    RUNABannerAdSpotBranchId8,
    RUNABannerAdSpotBranchId9,
    RUNABannerAdSpotBranchId10,
    RUNABannerAdSpotBranchId11,
    RUNABannerAdSpotBranchId12,
    RUNABannerAdSpotBranchId13,
    RUNABannerAdSpotBranchId14,
    RUNABannerAdSpotBranchId15,
    RUNABannerAdSpotBranchId16,
    RUNABannerAdSpotBranchId17,
    RUNABannerAdSpotBranchId18,
    RUNABannerAdSpotBranchId19,
    RUNABannerAdSpotBranchId20,
};
/*!
 RUNA ads container view extends from UIView.
 */
@interface RUNABannerView : UIView

/// unique id from admin site, required when `adSpotCode` is nil.
@property(nonatomic, copy, nullable) NSString* adSpotId;
/// unique code from admin site, required when `adSpotId` is nil.
@property(nonatomic, copy, nullable) NSString* adSpotCode;
/// indicate AdSpot's branch Id.
@property(nonatomic) RUNABannerAdSpotBranchId adSpotBranchId;


/// @enum size indicate content size
@property(nonatomic) RUNABannerViewSize size;
/// @enum position setting in superview
@property(nonatomic) RUNABannerViewPosition position;
/// aditional info
@property(nonatomic, nullable) NSDictionary* properties;
/// avoid duplicated ad contents in same session
@property(nonatomic, weak, nullable) RUNAAdSession* session;

/// direct url when ad is clicked
@property(nonatomic, readonly, nullable) NSString* clickURL;
/// prevent opening URL in system browser as default action when clicking
@property(nonatomic) BOOL shouldPreventDefaultClickAction;

/*!
 Request & load ad content without event handler.
 */
-(void) load;

/*!
 Request & load ad content with a handler.
 @param handler
    callback to handle variety events.
 */
-(void) loadWithEventHandler:(nullable void (^)(RUNABannerView* view, struct RUNABannerViewEvent event)) handler;

@end

NS_ASSUME_NONNULL_END

#endif
