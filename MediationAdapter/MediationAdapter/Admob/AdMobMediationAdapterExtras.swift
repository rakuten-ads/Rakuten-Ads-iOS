//
//  AdMobMediationAdapterExtras.swift
//  MediationAdapter
//
//  Created by Wu, Wei | David | GATD on 2024/05/27.
//

import Foundation
import GoogleMobileAds
import RUNABanner

public class AdMobMediationAdapterExtras: NSObject, GADAdNetworkExtras {

    public var adspotId: String!

    public var rz: String?

    public var rp: String?

    public var easyId: String?

    public var rpoint: Int?

    public var customTargeting: [String: [Any]]?

    public var genre: RUNABannerViewGenreProperty?

    public func applyTo(bannerView: RUNABannerView) {
        bannerView.adSpotId = adspotId

        if let rz {
            bannerView.setRz(rz)
        }

        if let rp {
            bannerView.setRp(rp)
        }

        if let easyId {
            bannerView.setEasyId(easyId)
        }

        if let rpoint {
            bannerView.setRpoint(rpoint)
        }

        if let customTargeting {
            bannerView.setCustomTargeting(customTargeting)
        }

        if let genre {
            bannerView.setPropertyGenre(genre)
        }
    }
}
