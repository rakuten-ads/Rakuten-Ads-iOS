//
//  RUNAMediationAdapterAdmobExtras.h
//  MediationAdapterObj
//
//  Created by Wu, Wei | David | GATD on 2024/06/05.
//

#import <Foundation/Foundation.h>
#import "RUNAAdParameter.h"
#import <RUNABanner/RUNABanner.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface RUNAMediationAdapterAdmobExtras : NSObject<GADAdNetworkExtras>

@property RUNAAdParameter* adParameter;

-(void) applyToBannerView:(RUNABannerView*) runaBanner;

@end

NS_ASSUME_NONNULL_END
