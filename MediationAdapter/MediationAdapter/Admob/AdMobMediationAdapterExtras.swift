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

    public let parameters: RunaAdParameter

    public init(parameters: RunaAdParameter) {
        self.parameters = parameters
    }

    func applyTo(bannerView: RUNABannerView) {
        debug("apply RunaAdParameters to banner: \(parameters)")
        bannerView.adSpotId = parameters.adSpotId
        bannerView.adSpotCode = parameters.adSpotCode
        bannerView.adSpotBranchId = RUNABannerAdSpotBranch(rawValue: UInt(parameters.adSpotBranchId)) ?? .idNone

        if let rz = parameters.rz {
            bannerView.setRz(rz)
        }

        if let rp = parameters.rp {
            bannerView.setRp(rp)
        }

        if let easyId = parameters.easyId {
            bannerView.setEasyId(easyId)
        }

        bannerView.setRpoint(parameters.rpoint)
        
        if let customTargeting = parameters.customTargeting {
            bannerView.setCustomTargeting(customTargeting)
        }

        if let genre = parameters.genre {
            let genreProperty = RUNABannerViewGenreProperty(masterId: genre.masterId, code: genre.code, match: genre.match)
            bannerView.setPropertyGenre(genreProperty)
        }
    }
}
