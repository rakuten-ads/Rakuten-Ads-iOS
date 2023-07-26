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

@protocol RUNAMeasurable <NSObject>

@end

#pragma mark - Viewable Observer Delegate

@protocol RUNAMeasurerDelegate <NSObject>

@optional
/**
 @param isImp result of imp measured
 @return YES for completing measurement, otherwise false
 */
- (BOOL)didMeasureImp:(BOOL) isImp;

/**
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

@protocol RUNAMeasurer <NSObject>

/*!
 set a target which implemented protocol RUNAMeasurable
 @param target measurable target
 */
-(void) setMeasureTarget:(id<RUNAMeasurable>)target;
-(void) setMeasurerDelegate:(id<RUNAMeasurerDelegate>)measurerDelegate;
-(void) startMeasurement;
-(void) finishMeasurement;

@end

#pragma mark - default measurement

@protocol RUNADefaultMeasurement <RUNAMeasurable>

-(id<RUNAMeasurer>) getDefaultMeasurer;
-(BOOL) measureImp;
-(BOOL) measureInview;

@end

@interface RUNADefaultMeasurer: NSObject<RUNAMeasurer>

@property BOOL isVideoTrack;

@end

#pragma mark - open measurement

@protocol RUNAOpenMeasurement <RUNAMeasurable>

-(id<RUNAMeasurer>) getOpenMeasurer;
-(UIView*) getOMAdView;
-(nullable WKWebView*) getOMWebView;
-(NSString*) injectOMProvider:(NSString*) omProviderURL IntoHTML:(NSString*) html;
@end


NS_ASSUME_NONNULL_END
