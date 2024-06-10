//
//  RUNAMediationAdapterAdmobExtras.m
//  MediationAdapterObj
//
//  Created by Wu, Wei | David | GATD on 2024/06/05.
//

#import "RUNAMediationAdapterAdmobExtras.h"

@implementation RUNAMediationAdapterAdmobExtras

-(void)applyToBannerView:(RUNABannerView *)runaBanner {
    RUNADebug("apply RUNAAdParameter to banner: %@", self.adParameter);

    runaBanner.adSpotId = self.adParameter.adSpotId;
    runaBanner.adSpotCode = self.adParameter.adSpotCode;
    runaBanner.adSpotBranchId = self.adParameter.adSpotBranchId;
    [runaBanner setRz:self.adParameter.rz];
    [runaBanner setRp:self.adParameter.rp];
    [runaBanner setEasyId:self.adParameter.easyId];
    [runaBanner setRpoint:self.adParameter.rpoint];
    [runaBanner setCustomTargeting:self.adParameter.customTargeting];
    [runaBanner setPropertyGenre:self.adParameter.genre];
}

@end
