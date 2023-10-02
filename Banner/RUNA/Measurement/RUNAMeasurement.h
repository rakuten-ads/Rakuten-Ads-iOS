//
//  RUNAMeasurement.h
//  RUNA
//
//  Created by Wu, Wei b on 2019/08/19.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Declare as a measurement target
 */
@protocol RUNAMeasurable <NSObject>

@end

#pragma mark - Viewable Observer Delegate

/*!
 Delegate for the events of measurement
 */
@protocol RUNAMeasurerDelegate <NSObject>

@optional
/**
 Call when the imp event measured.
 @param isImp result of imp measured
 @return YES for completing measurement, otherwise false
 */
- (BOOL)didMeasureImp:(BOOL) isImp;

/**
 Call when view ability event measured
 @param isInview result of in view measured
 @return YES for completing measurement, otherwise false
 */
- (BOOL)didMeasureInview:(BOOL)isInview;

/**
 @param isInview result of in view measured
 @return YES for completing measurement, otherwise false
 */
- (BOOL)didMeasureVideoTrack:(BOOL)isInview;

@end

/*!
 Protocol defines an object conducts the measurement.
 */
@protocol RUNAMeasurer <NSObject>

/*!
 set a target which implemented protocol RUNAMeasurable
 @param target measurable target
 */
-(void) setMeasureTarget:(id<RUNAMeasurable>)target;

/*!
 set a delegate which implemented protocol RUNAMeasurerDelegate
 @param measurerDelegate delegate for events during measurement
 */
-(void) setMeasurerDelegate:(id<RUNAMeasurerDelegate>)measurerDelegate;

/*!
 start measurement
 */
-(void) startMeasurement;

/*!
 finish measurement
 */
-(void) finishMeasurement;

@end

#pragma mark - default measurement
/*!
 A target adapts RUNA measurement
 */
@protocol RUNADefaultMeasurement <RUNAMeasurable>

/*!
 Get a measurer object conducts RUNA measurement
 @Return the measurer object
 */
-(id<RUNAMeasurer>) getDefaultMeasurer;

/*!
 The process of measuring imp
 @Return YES for imp detected
 */
-(BOOL) measureImp;

/*!
 The process of measuring view-ability
 @Return YES for inview detected
 */
-(BOOL) measureInview;

@end

/*!
 Implement protocol RUNAMeasurer for RUNA measurement
 */
@interface RUNADefaultMeasurer: NSObject<RUNAMeasurer>

/*!
 True for video track measurement
 */
@property BOOL isVideoTrack;

@end

#pragma mark - open measurement

/*!
 Protocol defines a target support OM measurement
 */
@protocol RUNAOpenMeasurement <RUNAMeasurable>

/*!
 Get a measurer object conducts OM measurement
 */
-(id<RUNAMeasurer>) getOpenMeasurer;

/*!
 Get target view of OM measurement
 */
-(UIView*) getOMAdView;

/*!
 Get the WebView contained by the target view
 */
-(nullable WKWebView*) getOMWebView;

/*!
 Inject OMSDK javascript content into the ad HTML template before ad loaded in WebView.
 - Parameters:
   - omProviderURL: OMSDK js resource URL
   - html: ad HTML content
 - Returns: updated HTML content
 */
-(NSString*) injectOMProvider:(NSString*) omProviderURL IntoHTML:(NSString*) html;
@end


NS_ASSUME_NONNULL_END
