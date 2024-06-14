//
//  GADMediationAdapterRunaBanner.m
//  MediationAdapterObj
//
//  Created by Wu, Wei | David | GATD on 2024/06/05.
//

#import "GADMediationAdapterRunaBanner.h"
#import "GADMediationAdapterRunaExtras.h"
#import "GADMediationAdapterRunaUtil.h"
#import <RUNACore/RUNACore.h>

@interface GADMediationAdapterRunaBanner()

@property(readonly) RUNABannerView* bannerView;
@property(copy) GADMediationBannerLoadCompletionHandler completionHandler;
@property id<GADMediationBannerAdEventDelegate> adEventDelegate;

@end

@implementation GADMediationAdapterRunaBanner

-(UIView *)view {
    return self.bannerView;
}

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {

    RUNADebug("loadBannerForAdConfiguration: %@", adConfiguration);

    if (adConfiguration.extras && [adConfiguration.extras isKindOfClass:GADMediationAdapterRunaExtras.class]) {
        GADMediationAdapterRunaExtras* extras = (GADMediationAdapterRunaExtras*) adConfiguration.extras;
        self.completionHandler = completionHandler;

        RUNABannerView* runaBanner = [RUNABannerView new];
        runaBanner.size = RUNABannerViewSizeAspectFit;
        runaBanner.position = RUNABannerViewPositionTop;

        [extras applyToBannerView:runaBanner];
        self->_bannerView = runaBanner;

        __weak typeof(self) weakSelf = self;
        [self.bannerView loadWithEventHandler:^(RUNABannerView * _Nonnull view, struct RUNABannerViewEvent event) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                RUNALog("[RUNA] runa instance has been deallocated before completionHandler");
                return;
            }
            if (event.eventType == RUNABannerViewEventTypeSucceeded) {
                GADAdSize verifiedSize = GADClosestValidSizeForAdSizes(
                                                                 adConfiguration.adSize,
                                                                 @[NSValueFromGADAdSize(GADAdSizeFromCGSize(strongSelf.bannerView.designatedContentSize))]
                                                                       );

                if (IsGADAdSizeValid(verifiedSize)) {
                    RUNADebug("[RUNA] GAD adapter completionHandler succeed on verified GADSize %@",
                            NSStringFromCGSize(CGSizeFromGADAdSize(verifiedSize)));
                    strongSelf.adEventDelegate = strongSelf.completionHandler(strongSelf, nil);
                } else {
                    NSError* err = [GADMediationAdapterRunaUtil
                                    domainError:RUNABannerViewErrorFatal
                                    withDescription: [NSString
                                                      stringWithFormat:@"RUNA Banner size is not match for verified GADSize %@",
                                                      NSStringFromCGSize(CGSizeFromGADAdSize(verifiedSize))]];
                    RUNALog("[RUNA] GAD adapter completionHandler failed: %@", err);
                    strongSelf.adEventDelegate = strongSelf.completionHandler(nil, err); // TODO: is possible to pass weakself?
                }
            } else if(event.eventType == RUNABannerViewEventTypeFailed) {
                NSError* err = [GADMediationAdapterRunaUtil
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
