//
//  AdMobMediationAdapterBanner.swift
//  MediationAdapter
//
//  Created by Wu, Wei | David | GATD on 2024/05/21.
//

import Foundation
import RUNABanner
import GoogleMobileAds

class AdmobMedationAdapterBanner: NSObject, GADMediationBannerAd {
    var view: UIView {
        if let banner = self.banner {
            return banner
        } else {
            debug("banner not ready")
            return UIView()
        }
    }

    private var banner: RUNABannerView?
    var adEventDelegate: GADMediationAdEventDelegate?

    func loadBanner(for adConfiguration: GADMediationBannerAdConfiguration, 
                    completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        
        debug("load adConfiguration settings: \(adConfiguration.credentials.settings)")
        if let extras = adConfiguration.extras as? AdMobMediationAdapterExtras {
            let banner = RUNABannerView()
            self.banner = banner

            banner.size = .aspectFit
            banner.position = .top

            extras.applyTo(bannerView: banner)

            banner.load { [weak self] bannerView, event in
                debug("received banner event \(event.eventType.rawValue)")
                switch event.eventType {
                case .succeeded:
                    let verifiedSize = GADClosestValidSizeForAdSizes(
                        adConfiguration.adSize,
                        [NSValueFromGADAdSize(GADAdSizeFromCGSize(bannerView.designatedContentSize))]
                    )

                    if IsGADAdSizeValid(verifiedSize) {
                        self?.adEventDelegate = completionHandler(self, nil)
                    } else {
                        let err = AdMobMediationAdapterUtil.convertError(
                            from: RUNABannerViewError.fatal, description: "RUNA Banner size is not match for indicated GADSize")
                        self?.adEventDelegate = completionHandler(nil, err)
                    }

                case .failed:
                    let err = AdMobMediationAdapterUtil.convertError(
                        from: event.error, description: "ad load failed with error: \(event.error.rawValue)")
                    self?.adEventDelegate = completionHandler(nil, err)
                case .clicked:
                    self?.adEventDelegate?.reportClick()
                default:
                    debug("unsupport event \(event.eventType)")
                }

            }
        }
    }

}
