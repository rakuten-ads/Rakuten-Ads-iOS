//
//  AdMobMediationAdapterUtil.swift
//  MediationAdapter
//
//  Created by Wu, Wei | David | GATD on 2024/05/21.
//

import Foundation
import RUNABanner

class AdMobMediationAdapterUtil {

    static let kGADMediationAdapterRunaDomain = "com.rakuten.runa.mediation.admob"

    static func convertError(from error: RUNABannerViewError, description: String) -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey : description,
            NSLocalizedFailureReasonErrorKey : description
        ]
        return NSError(domain: kGADMediationAdapterRunaDomain, code: Int(error.rawValue), userInfo: userInfo)
    }
}
