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

    static let kSDKVersion = "1.0.0" // TODO: update when releasing, last since 2024/05/30

    private var bannerLoader: AdmobMedationAdapterBanner?

    public static func networkExtrasClass() -> (any GADAdNetworkExtras.Type)? {
        return AdMobMediationAdapterExtras.self
    }

    public static func setUpWith(_ configuration: GADMediationServerConfiguration, 
                                 completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock) {

        completionHandler(nil)
    }

    // MARK: - banner
    public func loadBanner(for adConfiguration: GADMediationBannerAdConfiguration, 
                           completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        
        info("load Banner")
        self.bannerLoader = AdmobMedationAdapterBanner()
        self.bannerLoader?.loadBanner(for: adConfiguration, completionHandler: completionHandler)
    }

    // MARK: - version info
    public static func adapterVersion() -> GADVersionNumber {
        return parseVersion(string: kSDKVersion)
    }

    public static func adSDKVersion() -> GADVersionNumber {
        var ver = GADVersionNumber(majorVersion: 0, minorVersion: 0, patchVersion: 0)
        if RUNABannerView.self.responds(to: Selector(("RUNASDKVersionString"))) {
            if let verString = RUNABannerView.self.perform(Selector(("RUNASDKVersionString"))).takeRetainedValue() as? String {
                print(verString)
                ver = parseVersion(string: verString)
            }
        }
        return ver
    }

    private static func parseVersion(string: String) -> GADVersionNumber {
        var ver = GADVersionNumber(majorVersion: 0, minorVersion: 0, patchVersion: 0)
        let vers = string.split(separator: ".")
        if vers.count > 2 {
            ver.majorVersion = Int(vers[0]) ?? 1
            ver.minorVersion = Int(vers[1]) ?? 0
            ver.patchVersion = Int(vers[2]) ?? 0
        }
        return ver
    }
}
