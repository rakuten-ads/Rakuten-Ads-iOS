# Mediation Usage Manual

This manual introduces the usage of ad mediation as implemented in `Mediation.swift`. It covers the integration of RUNABanner with AdMob via the RUNAMediationAdapter, configuration, event handling, and best practices for using mediation in your iOS application.

---

## 1. Overview

Ad mediation allows you to serve ads from multiple networks, optimizing fill rate and revenue. This example demonstrates mediation between RUNABanner and AdMob using the RUNAMediationAdapter.

---

## 2. Basic Integration with AdMob

### Step 1: Import Required Modules

```swift
import RUNABanner
import RUNAMediationAdapter
import GoogleMobileAds
```

### Step 2: Create and Configure the AdMob Banner

```swift
let gadBanner = GoogleMobileAds.BannerView(adSize: AdSizeBanner)
gadBanner.adUnitID = "ca-app-pub-3940256099942544/2934735716" // Test Ad Unit ID
gadBanner.rootViewController = self
gadBanner.delegate = self
```

### Step 3: Prepare the AdRequest and Mediation Extras

```swift
let adRequest = AdRequest(adSpot: .init(adSpotId: "ad_spot_id_mediation_admob"))
let extras = AdMobMediationAdapterExtras(adRequest: adRequest)
```

### Step 4: Register Extras and Load the Ad

```swift
let req = Request()
req.register(extras)
gadBanner.load(req)
self.view.addSubview(gadBanner)
```

---

## 3. Event Handling

Implement the `BannerViewDelegate` methods to handle ad events:

```swift
func bannerViewDidReceiveAd(_ bannerView: GoogleMobileAds.BannerView) {
    print("gad bannerView - bannerViewDidReceiveAd")
}

func bannerView(_ bannerView: GoogleMobileAds.BannerView, didFailToReceiveAdWithError error: any Error) {
    print("gad bannerView - didFailToReceiveAdWithError: \(error.localizedDescription)")
}

func bannerViewDidRecordClick(_ bannerView: GoogleMobileAds.BannerView) {
    print("gad bannerView - DidRecordClick")
}

func bannerViewDidRecordImpression(_ bannerView: GoogleMobileAds.BannerView) {
    print("gad bannerView - DidRecordImpression")
}
```

---

## 4. Best Practices

- Always use a valid AdMob ad unit ID for production.
- Register mediation extras before loading the ad.
- Implement all delegate methods for robust event handling and analytics.
- Add the banner view to your view hierarchy after loading.

---

## 5. Example: Complete Integration

```swift
class MediationSampleViewController: UIViewController, BannerViewDelegate {
    private func mediationWithAdmob() {
        let gadBanner = GoogleMobileAds.BannerView(adSize: AdSizeBanner)
        gadBanner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        gadBanner.rootViewController = self
        gadBanner.delegate = self

        let adRequest = AdRequest(adSpot: .init(adSpotId: "ad_spot_id_mediation_admob"))
        let extras = AdMobMediationAdapterExtras(adRequest: adRequest)

        let req = Request()
        req.register(extras)

        gadBanner.load(req)
        self.view.addSubview(gadBanner)
    }

    // ...delegate methods...
}
```

---

## 6. Troubleshooting

- Ensure the ad unit ID and ad spot ID are correct and active.
- Check for network connectivity if the ad fails to load.
- Review console output for error details.

---

## 7. References

- [RUNABanner SDK Documentation](#)
- [RUNAMediationAdapter Documentation](#)
- [GoogleMobileAds Documentation](#)
- [SampleCode/Mediation.swift](./Mediation.swift)

For further assistance, refer to the official SDK documentation or contact support.
