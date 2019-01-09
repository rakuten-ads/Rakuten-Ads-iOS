#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GAPAdViewPosition) {
    GAP_ADVIEW_POSITION_CUSTOM,
    GAP_ADVIEW_POSITION_TOP,
    GAP_ADVIEW_POSITION_BOTTOM,
    GAP_ADVIEW_POSITION_TOP_LEFT,
    GAP_ADVIEW_POSITION_TOP_RIGHT,
    GAP_ADVIEW_POSITION_BOTTOM_LEFT,
    GAP_ADVIEW_POSITION_BOTTOM_RIGHT,
};

typedef NS_ENUM(NSUInteger, GAPAdViewEvent) {
    GAP_ADVIEW_EVENT_SUCCEEDED,
    GAP_ADVIEW_EVENT_FAILED,
    GAP_ADVIEW_EVENT_CLICKED,
};

@class GAPAdView;

@interface GAPAdView : UIView

@property(nonatomic, copy, nonnull) NSString* adSpotId;

-(void) show;
-(void) showWithEventHandler:(nullable BOOL (^)(GAPAdViewEvent event)) handler;
-(void) setPosition:(GAPAdViewPosition)position inView:(UIView*) parentView;

@end
