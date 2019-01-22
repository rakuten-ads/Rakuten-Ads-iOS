#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RPSAdViewPosition) {
    RPS_ADVIEW_POSITION_CUSTOM,
    RPS_ADVIEW_POSITION_TOP,
    RPS_ADVIEW_POSITION_BOTTOM,
    RPS_ADVIEW_POSITION_TOP_LEFT,
    RPS_ADVIEW_POSITION_TOP_RIGHT,
    RPS_ADVIEW_POSITION_BOTTOM_LEFT,
    RPS_ADVIEW_POSITION_BOTTOM_RIGHT,
};

typedef NS_ENUM(NSUInteger, RPSAdViewEvent) {
    RPS_ADVIEW_EVENT_SUCCEEDED,
    RPS_ADVIEW_EVENT_FAILED,
    RPS_ADVIEW_EVENT_CLICKED,
};

@class RPSAdView;

@interface RPSAdView : UIView

@property(nonatomic, copy, nonnull) NSString* adSpotId;

-(void) show;
-(void) showWithEventHandler:(nullable BOOL (^)(RPSAdViewEvent event)) handler;
-(void) setPosition:(RPSAdViewPosition)position inView:(UIView*) parentView;

@end
