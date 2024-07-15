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

    RUNADebug("[RUNA MDA] loadBannerForAdConfiguration: %@", adConfiguration);

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
                RUNALog("[RUNA MDA] runa instance has been deallocated before completionHandler");
                return;
            }
            if (event.eventType == RUNABannerViewEventTypeSucceeded) {
                if ([strongSelf verifyAdSize:strongSelf.bannerView.designatedContentSize withRequestSize:adConfiguration.adSize]) {
                    RUNADebug("[RUNA MDA] GAD adapter completionHandler succeed on request GADSize %@",
                            NSStringFromCGSize(CGSizeFromGADAdSize(adConfiguration.adSize)));
                    strongSelf.adEventDelegate = strongSelf.completionHandler(strongSelf, nil);
                } else {
                    NSError* err = [GADMediationAdapterRunaUtil
                                    domainError:RUNABannerViewErrorFatal
                                    withDescription: [NSString
                                                      stringWithFormat:@"[RUNA MDA] RUNA Banner designated size %@ is not match for request GADSize %@",
                                                      NSStringFromCGSize(strongSelf.bannerView.designatedContentSize),
                                                      NSStringFromCGSize(CGSizeFromGADAdSize(adConfiguration.adSize))
                                                     ]];
                    RUNALog("[RUNA MDA] GAD adapter completionHandler failed: %@", err);
                    strongSelf.adEventDelegate = strongSelf.completionHandler(nil, err);
                }
            } else if(event.eventType == RUNABannerViewEventTypeFailed) {
                NSError* err = [GADMediationAdapterRunaUtil
                                domainError:event.error
                                withDescription: [NSString
                                                  stringWithFormat:@"[RUNA] RUNA SDK ad load failed with error: %lu",
                                                  (unsigned long)event.error]];
                RUNALog("[RUNA MDA] GAD adapter completionHandler failed: %@", err);
                strongSelf.adEventDelegate = strongSelf.completionHandler(nil, err);
            } else if (event.eventType == RUNABannerViewEventTypeClicked) {
                RUNALog("[RUNA MDA] GAD adapter report click");
                [strongSelf.adEventDelegate reportClick];
            }
        }];
    }
}

/*!
Verifiy RUNABanner size with requested GADAdSize. YES for either RUNABanner size is close to GADAdSize or the aspect ratio of 2 size has a distance less than 0.01.
 */
-(BOOL) verifyAdSize:(CGSize) adSize withRequestSize:(GADAdSize) requestSize {
    GADAdSize verifiedSize = GADClosestValidSizeForAdSizes(requestSize, @[
        NSValueFromGADAdSize(GADAdSizeFromCGSize(adSize))
    ]);
    RUNADebug("[RUNA MDA] GADClosestValidSizeForAdSizes = %@", NSStringFromCGSize(CGSizeFromGADAdSize(verifiedSize)));
    double aspectRatioDistance = fabs((requestSize.size.width / requestSize.size.height) - (adSize.width / adSize.height));

    RUNADebug("[RUNA MDA] AspectRatio distance = %f", aspectRatioDistance);
    return IsGADAdSizeValid(verifiedSize) || aspectRatioDistance < 0.01;
}

@end
