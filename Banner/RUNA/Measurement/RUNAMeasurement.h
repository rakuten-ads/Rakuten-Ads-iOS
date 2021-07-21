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

@protocol RUNAViewableObserverDelegate <NSObject>

- (void)didMeasurementInView:(BOOL)isMeasuredInview;

@end

@protocol RUNAMeasurer <NSObject>

-(void) setMeasureTarget:(id<RUNAMeasurable>)target;
-(void) setViewableObserverDelegate:(id<RUNAViewableObserverDelegate>)viewableObserverDelegate;
-(void) setIsVideoMeasuring:(BOOL)isVideoMeasuring;
-(void) startMeasurement;
-(void) finishMeasurement;

@end

#pragma mark - default measurement

@protocol RUNADefaultMeasurement <RUNAMeasurable>

-(id<RUNAMeasurer>) getDefaultMeasurer;
-(BOOL) measureImp;
-(BOOL) measureInview;
-(BOOL) sendMeasureImp;

@end

@interface RUNADefaultMeasurer: NSObject<RUNAMeasurer>

@end

#pragma mark - open measurement

@protocol RUNAOpenMeasurement <RUNAMeasurable>

-(id<RUNAMeasurer>) getOpenMeasurer;
-(UIView*) getOMAdView;
-(nullable WKWebView*) getOMWebView;
-(NSString*) injectOMProvider:(NSString*) omProviderURL IntoHTML:(NSString*) html;
@end


NS_ASSUME_NONNULL_END
