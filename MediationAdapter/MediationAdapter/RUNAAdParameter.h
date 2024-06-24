//
//  RUNAMediationAdapterAdmobAdPramameter.h
//  MediationAdapterObj
//
//  Created by Wu, Wei | David | GATD on 2024/06/05.
//

#import <Foundation/Foundation.h>
#import <RUNABanner/RUNABanner.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAAdParameter : NSObject

@property(nullable) NSString* adSpotId;
@property(nullable) NSString* adSpotCode;
@property RUNABannerAdSpotBranch adSpotBranchId;
@property(nullable) NSString* rz;
@property(nullable) NSString* rp;
@property(nullable) NSString* easyId;
@property NSInteger rpoint;
@property(nullable) NSDictionary* customTargeting ;
@property(nullable) RUNABannerViewGenreProperty* genre;

@end

NS_ASSUME_NONNULL_END
