//
//  AdMobMediationAdapter.swift
//  MediationAdapter
//
//  Created by Wu, Wei | David | GATD on 2024/05/20.
//

import Foundation
import GoogleMobileAds
import RUNABanner

@objc
public final class AdmobMedationAdapter: NSObject, GADMediationAdapter {

    private var bannerLoader: AdmobMedationAdapterBanner?

    public static func adapterVersion() -> GADVersionNumber {
        return GADVersionNumber(majorVersion: 1, minorVersion: 0, patchVersion: 0)
    }

    public static func adSDKVersion() -> GADVersionNumber {
        var ver = GADVersionNumber(majorVersion: 0, minorVersion: 0, patchVersion: 0)
        if RUNABannerView.self.responds(to: Selector(("RUNASDKVersionString"))) {
            if let verString = RUNABannerView.self.perform(Selector(("RUNASDKVersionString"))).takeRetainedValue() as? String {
                print(verString)
                let vers = verString.split(separator: ".")
                if vers.count == 3 {
                    ver.majorVersion = Int(vers[0]) ?? 0
                    ver.minorVersion = Int(vers[1]) ?? 0
                    ver.patchVersion = Int(vers[2]) ?? 0
                }
            }

        }
        return ver
    }

    public static func networkExtrasClass() -> (any GADAdNetworkExtras.Type)? {
        return AdMobMediationAdapterExtras.self
    }

    public static func setUpWith(_ configuration: GADMediationServerConfiguration, completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock) {
        completionHandler(nil)
    }

    public func loadBanner(for adConfiguration: GADMediationBannerAdConfiguration, completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        info("load Banner")
        self.bannerLoader = AdmobMedationAdapterBanner()
        self.bannerLoader?.loadBanner(for: adConfiguration, completionHandler: completionHandler)
    }

}
