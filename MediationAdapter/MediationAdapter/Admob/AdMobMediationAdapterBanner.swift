//
//  AdMobMediationAdapterBanner.swift
//  MediationAdapter
//
//  Created by Wu, Wei | David | GATD on 2024/05/21.
//

import Foundation
import RUNABanner
import GoogleMobileAds

struct RUNAParameter: Decodable {
    let adSpotId: String
}

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

    func loadBanner(for adConfiguration: GADMediationBannerAdConfiguration, completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        debug("load adConfiguration settings: \(adConfiguration.credentials.settings)")
//        if let parameterString = adConfiguration.credentials.settings["parameter"] as? String,
//           let jsonData = parameterString.data(using: .utf8) {
//            if let parameters = try? JSONDecoder().decode(RUNAParameter.self, from: jsonData) {
                let banner = RUNABannerView()
                self.banner = banner
        
                banner.size = .aspectFit
                banner.position = .top

                if let extras = adConfiguration.extras as? AdMobMediationAdapterExtras {
                    extras.applyTo(bannerView: banner)
                }

//                info("RUNABannerView load with parameters: \(parameters)")
                banner.load { [weak self] bannerView, event in
                    debug("received banner event \(event.eventType.rawValue)")
                    switch event.eventType {
                    case .succeeded:
                        self?.adEventDelegate = completionHandler(self, nil)
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
//            } else {
//                debug("malformed parameter string: [\(parameterString)]")
//            }
//        } else {
//            debug("mediation configuration parameter not found")
//        }
    }
}
