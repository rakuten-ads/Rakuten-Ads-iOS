#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RPSAdViewPosition) {
    RPSAdViewPositionCustom,
    RPSAdViewPositionTop,
    RPSAdViewPositionBottom,
    RPSAdViewPositionTopLeft,
    RPSAdViewPositionTopRight,
    RPSAdViewPositionBottomLeft,
    RPSAdViewPositionBottomRight,
};

typedef NS_ENUM(NSUInteger, RPSAdViewEvent) {
    RPSAdViewEventSucceeded,
    RPSAdViewEventFailed,
    RPSAdViewEventClicked,
};

@class RPSAdView;

@interface RPSAdView : UIView

@property(nonatomic, copy, nonnull) NSString* adSpotId;

-(void) load;
-(void) loadWithEventHandler:(nullable BOOL (^)(RPSAdView* view, RPSAdViewEvent event)) handler;
-(void) setPosition:(RPSAdViewPosition)position inView:(UIView*) parentView;

@end
