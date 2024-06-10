//
//  RUNAMediationAdapterAdmobBanner.m
//  MediationAdapterObj
//
//  Created by Wu, Wei | David | GATD on 2024/06/05.
//

#import "RUNAMediationAdapterAdmobBanner.h"
#import "RUNAMediationAdapterAdmobExtras.h"
#import "RUNAMediationAdapterAdmobUtil.h"
#import <RUNACore/RUNACore.h>

@interface RUNAMediationAdapterAdmobBanner()

@property(readonly) RUNABannerView* bannerView;
@property(copy) GADMediationBannerLoadCompletionHandler completionHandler;
@property id<GADMediationBannerAdEventDelegate> adEventDelegate;

@end

@implementation RUNAMediationAdapterAdmobBanner

-(UIView *)view {
    return self.bannerView;
}

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {

    RUNADebug("loadBannerForAdConfiguration: %@", adConfiguration);

    if (adConfiguration.extras && [adConfiguration.extras isKindOfClass:RUNAMediationAdapterAdmobExtras.class]) {
        RUNAMediationAdapterAdmobExtras* extras = (RUNAMediationAdapterAdmobExtras*) adConfiguration.extras;
        self.completionHandler = completionHandler;

        RUNABannerView* runaBanner = [RUNABannerView new];
        [extras applyToBannerView:runaBanner];
        self->_bannerView = runaBanner;

        __weak typeof(self) weakSelf = self;
        [self.bannerView loadWithEventHandler:^(RUNABannerView * _Nonnull view, struct RUNABannerViewEvent event) {
            if (!weakSelf) {
                RUNALog("[RUNA] runa instance has deallocated before completionHandler");
                return;
            }
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (event.eventType == RUNABannerViewEventTypeSucceeded) {
                RUNALog("[RUNA] GAD adapter completionHandler succeeeded");

                GADAdSize verifiedSize = GADClosestValidSizeForAdSizes(
                                                                 adConfiguration.adSize,
                                                                 @[NSValueFromGADAdSize(GADAdSizeFromCGSize(strongSelf.bannerView.designatedContentSize))]
                                                                       );

                if (IsGADAdSizeValid(verifiedSize)) {
                    RUNALog("[RUNA] GAD adapter completionHandler succeed on verified GADSize %@",
                            NSStringFromCGSize(CGSizeFromGADAdSize(verifiedSize)));
                    strongSelf.adEventDelegate = strongSelf.completionHandler(strongSelf, nil);
                } else {
                    NSError* err = [RUNAMediationAdapterAdmobUtil
                                    domainError:RUNABannerViewErrorFatal
                                    withDescription: [NSString
                                                      stringWithFormat:@"RUNA Banner size is not match for verified GADSize %@",
                                                      NSStringFromCGSize(CGSizeFromGADAdSize(verifiedSize))]];
                    RUNALog("[RUNA] GAD adapter completionHandler failed: %@", err);
                    strongSelf.adEventDelegate = strongSelf.completionHandler(nil, err); // TODO: is possible to pass weakself?
                }
            } else if(event.eventType == RUNABannerViewEventTypeFailed) {
                NSError* err = [RUNAMediationAdapterAdmobUtil
                                domainError:event.error
                                withDescription: [NSString
                                                  stringWithFormat:@"[RUNA] RUNA SDK ad load failed with error: %lu",
                                                  (unsigned long)event.error]];
                RUNALog("[RUNA] GAD adapter completionHandler failed: %@", err);
                strongSelf.adEventDelegate = strongSelf.completionHandler(nil, err); // TODO: is possible to pass weakself?
            } else if (event.eventType == RUNABannerViewEventTypeClicked) {
                RUNALog("[RUNA] GAD adapter report click");
                [strongSelf.adEventDelegate reportClick];
            }
        }];
    }
}

@end
