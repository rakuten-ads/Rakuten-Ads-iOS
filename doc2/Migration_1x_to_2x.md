# Migration Guide: RUNA SDK 1.x → 2.x

This guide helps you migrate an existing RUNA SDK 1.x integration to 2.x.

Version 2.x is Swift-first, updates core API naming, and standardizes ad loading around `AdRequest` and `AdEvent`.

---

## 1. Before You Start

- Back up your current integration branch.
- Confirm your app/build environment meets 2.x prerequisites:
  - iOS 15+
  - Xcode 16+
- Collect existing 1.x usage points in your app:
  - Banner (`RUNABannerView`)
  - Group/Carousel (`RUNABannerGroup`, `RUNABannerCarouselView`)
  - Interstitial (`RUNAInterstitialAd`)
  - Measurement (`RUNAViewabilityProvider`)
  - Mediation (`RUNAMediationAdapter`)

---

## 2. Dependency Migration

### 1.x (example)

```ruby
source "https://github.com/rakuten-ads/Rakuten-Ads-iOS"
pod 'RUNA/Banner'
# optional
pod 'RUNA/OMAdapter'
pod 'RUNA/MediationAdapter'
```

### 2.x (SPM only, for Cocoapods support stopped)

Use package URL:

`https://github.com/rakuten-ads/Rakuten-Ads-iOS`

Select required products depending on your use case:

- `RUNABanner`
- `RUNAOMAdapter`, `OMSDK_Rakuten` (if OM measurement is needed)
- `RUNAMediationAdapter` (if mediation is needed)

---

## 3. Quick API Mapping (1.x → 2.x)

| 1.x | 2.x |
|---|---|
| `RUNABannerView` | `BannerView` |
| `RUNABannerGroup` | `BannerGroup` |
| `RUNABannerCarouselView` | `BannerCarouselView` |
| `RUNAInterstitialAd` | `InterstitialAd` |
| `RUNAViewabilityProvider` | `ViewMeasurementProvider` |
| `RUNAMeasurableTarget` | `UIViewTarget`,`OMNativeViewMeasurableTarget` |
| `loadWithEventHandler(...)` | `load(adRequest:eventHandler:)` |
| `preloadWithEventHandler(...)` | `preload(adRequest:eventHandler:)` |
| `RUNABannerViewEventTypeSucceeded` | `AdEvent.success` |
| `RUNABannerViewEventTypeFailed` | `AdEvent.failed(Error)` |
| `RUNABannerViewEventTypeClicked` | `AdEvent.clicked(Url)` |
| `RUNABannerViewEventTypeInterstitialClosed` | `AdEvent.interstitialClosed` |
| `RUNABannerViewEventTypeGroupFailed` | `AdEvent.groupFailed(Error)` |

---

## 4. Banner Migration

### 1.x style

```swift
let banner = RUNABannerView()
banner.adSpotId = "ad_spot_id"
banner.position = .bottom
banner.load { view, event in
    // handle RUNABannerViewEvent
}
```

### 2.x style

```swift
import RUNABanner

let bannerView = BannerView()
bannerView.position = .bottom
self.view.addSubview(bannerView)

let request = AdRequest(adSpot: .init(adSpotId: "ad_spot_id"))
bannerView.load(adRequest: request) { banner, adEvent in
    switch adEvent {
    case .success:
        print("Banner loaded")
    case .failed(let error):
        print("Failed: \(error)")
    case .clicked(let url):
        print("Clicked \(url)")
    default:
        break
    }
}
```

### Important changes

- Build ad parameters through `AdRequest` instead of mutating many banner properties directly.
- Add `BannerView` to view hierarchy before or during load flow.
- Event handling uses `AdEvent` enum instead of `RUNABannerViewEvent` struct/eventType.

---

## 5. Group / Carousel Migration

### Group

- Replace `RUNABannerGroup` with `BannerGroup`.
- Migrate from per-banner legacy setup to `AdRequest.adSpotList` arrays where applicable.
- Handle group events via `AdEvent` (`.groupFinished`, `.groupFailed(Error)`).

### Carousel

- Replace `RUNABannerCarouselView` with `BannerCarouselView`.
- Use `carouselView.load(adRequest:eventHandler:)`.
- Handle group events via `AdEvent` (`.groupFinished`, `.groupFailed(Error)`).

---

## 6. Interstitial Migration

### 1.x style

```swift
let interstitialAd = RUNAInterstitialAd()
interstitialAd.adSpotId = "ad_spot_id"
interstitialAd.size = .Custom
interstitialAd.decorator = {container, adview, closeButton in 
    // custom ui decoration
}
interstitialAd.preload { ad, event in
    // handle RUNABannerViewEvent
}
_ = interstitialAd.show(in: self)
```

### 2.x style

```swift
let interstitialAd = InterstitialAd()
interstitialAd.size - .custom({container, adview, closeButton in ...})
let adRequest = AdRequest(adSpot: .init(adSpotId: "ad_spot_id"))
interstitialAd.preload(adRequest: adRequest) { ad, adEvent in
    switch adEvent {
    case .success:
        print("Interstitial ready")
    case .failed(let error):
        print("Failed: \(error)")
    case .interstitialClosed:
        print("Closed")
    default:
        break
    }
}

_ = interstitialAd.show(in: self)
```

### Important changes

- Preload now explicitly takes `AdRequest`.
- Closed callback is handled via `AdEvent.interstitialClosed`.
- Full-screen behavior still configurable (`size`, `hideStatusBar`).

---

## 7. Measurement / OM Migration

### 1.x concepts

- `RUNAMeasurableTarget`
- `RUNAViewabilityProvider.sharedInstance().register(...)`
- `RUNAOMNativeProviderConfiguration`

### 2.x concepts

- `UIViewTarget` for standard UIVie measurement.
- `OMNativeViewMeasurableTarget` for OM on native view.
- `OMWebViewMeasurableTarget` for OM on web view.
- `ViewMeasurementProvider.shared.register(target: ...)`.

### 2.x example

```swift
let targetView = UIView()
let target = UIViewTarget(targetView: targetView, viewImpURL: "https://example.com") { _ in
    print("Measured")
}
try? ViewMeasurementProvider.shared.register(target: target)
```

---

## 8. Mediation (AdMob) Migration

### 1.x pattern

- Configure `RUNAAdParameter`.
- Register `GADMediationAdapterRunaExtras` before `GADBannerView.load`.

### 2.x pattern

- Build RUNA request with `AdRequest`.
- Wrap with `AdMobMediationAdapterExtras(adRequest:)`.
- Register extras into AdMob request and load.

```swift
import RUNABanner
import RUNAMediationAdapter
import GoogleMobileAds

let gadBanner = GoogleMobileAds.BannerView(adSize: AdSizeBanner)
let adRequest = AdRequest(adSpot: .init(adSpotId: "ad_spot_id_mediation_admob"))
let extras = AdMobMediationAdapterExtras(adRequest: adRequest)

let req = Request()
req.register(extras)
gadBanner.load(req)
```

---

## 9. Migration Checklist

- [ ] Replace 1.x SDK dependencies with 2.x products.
- [ ] Update imports and major type names (table above).
- [ ] Replace `RUNABannerViewEvent` handling with `AdEvent` switch.
- [ ] Move ad parameters into `AdRequest` creation.
- [ ] Validate banner/group/carousel callbacks.
- [ ] Validate interstitial preload/show flow and close callback.
- [ ] Validate measurement registration with `ViewMeasurementProvider`.
- [ ] Validate mediation extras flow (`AdMobMediationAdapterExtras`).
- [ ] Run full QA on ad fill, click-through, and impression tracking.

---

## 10. Reference Manuals (2.x)

- [BannerView](./banner/Banner_Manual.md)
- [BannerGroup](./banner/BannerGroup_Manual.md)
- [BannerView in SwiftUI](./banner/BannerSwiftUI_Manual.md)
- [CarouselView](./carousel/CarouselView_Manual.md)
- [InterstitialAd](./interstitial/InterstitialAd_Manual.md)
- [Measurement](./measurement/Measurement_Manual.md)
- [Mediation](./mediation/Mediation_Manual.md)
- [RUNA SDK API Documentation](https://rakuten-ads.github.io/runasdk.github.io/iOS/)
