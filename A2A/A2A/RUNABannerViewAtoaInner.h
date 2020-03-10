//
//  RUNABannerViewAtoaInner.h
//  A2A
//
//  Created by Wu, Wei b on 2019/12/12.
//  Copyright © 2019 Rakuten MPD. All rights reserved.
//

#import "RUNABannerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RUNABannerViewAppContent : NSObject

@property(nonatomic, readonly, copy, nullable) NSString* title;
@property(nonatomic, readonly, copy, nullable) NSArray<NSString*>* keywords;
@property(nonatomic, readonly, copy, nullable) NSString* url;

+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithTitle:(nullable NSString*) title keywords:(nullable NSArray<NSString*>*) keywords url:(nullable NSString*) url;


@end

@interface RUNABannerView(RUNA_Atoa)

-(void)setBannerViewAppContent:(RUNABannerViewAppContent*) appContent;

@end


NS_ASSUME_NONNULL_END
