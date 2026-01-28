# InterstitialAd Usage Manual

This manual introduces the usage of `InterstitialAd` as implemented in `InterstitialView.swift`. It covers all demonstrated cases, configuration options, event handling, and best practices for integrating interstitial ads in your iOS application.

---

## 1. Overview

`InterstitialAd` enables the display of full-screen ads that interrupt the user flow, typically shown between content transitions or at natural breaks in your app.

---

## 2. Basic Preloading and Presentation

### Preload an Interstitial Ad

```swift
let interstitialAd = InterstitialAd()
let adRequest = AdRequest(adSpot: .init(adSpotId: "ad_spot_id_interstitial"))
interstitialAd.preload(adRequest: adRequest) { interstitial, adEvent in
    switch adEvent {
    case .success:
        print("InterstitialAd loaded successfully")
    case .failed(let error):
        print("Failed to load InterstitialAd")
    case .interstitialClosed:
        print("InterstitialAd was closed by user")
        print("show next view controller or do other actions")
    default:
        break
    }
}
```

### Show the Interstitial Ad

```swift
if interstitialAd.show(in: self) {
    print("InterstitialAd presented successfully")
}
```

---

## 3. Full Screen Configuration

You can configure the interstitial ad to cover the entire screen and optionally hide the status bar:

```swift
interstitialAd.size = .fullScreen
interstitialAd.hideStatusBar = true // optional, false to keep status bar visible
let adRequest = AdRequest(adSpot: .init(adSpotId: "ad_spot_id_interstitial"))
interstitialAd.preload(adRequest: adRequest) { interstitial, adEvent in
    // ...handle events...
}
```

---

## 4. Event Handling

Events are handled in the `preload` callback:
- `.success`: Interstitial ad loaded successfully.
- `.failed(let error)`: Failed to load the interstitial ad.
- `.interstitialClosed`: The ad was closed by the user. Use this to trigger navigation or other actions.
- Other events: Ignored in this implementation.

---

## 5. Best Practices

- Always preload the interstitial ad before attempting to show it.
- Handle all relevant events for robust user experience.
- Use `.interstitialClosed` to trigger navigation or resume app flow.
- Configure `size` and `hideStatusBar` as needed for your app's UI.

---

## 6. Example: Complete Integration

```swift
class InterstitialViewSampleViewController: UIViewController {
    private var interstitialAd = InterstitialAd()

    private func preloadInterstitialAd() {
        let adRequest = AdRequest(adSpot: .init(adSpotId: "ad_spot_id_interstitial"))
        interstitialAd.preload(adRequest: adRequest) { interstitial, adEvent in
            switch adEvent {
            case .success:
                print("InterstitialAd loaded successfully")
            case .failed(let error):
                print("Failed to load InterstitialAd")
            case .interstitialClosed:
                print("InterstitialAd was closed by user")
                print("show next view controller or do other actions")
            default:
                break
            }
        }
    }

    private func showInterstitialAd() {
        if interstitialAd.show(in: self) {
            print("InterstitialAd presented successfully")
        }
    }
}
```

---

## 7. Troubleshooting

- Ensure the ad spot ID is correct and active.
- Check for network connectivity if the ad fails to load.
- Review console output for error details.

---

## 8. References

- [RUNABanner SDK Documentation](#)
- [SampleCode/InterstitialView.swift](./InterstitialView.swift)

For further assistance, refer to the official SDK documentation or contact support.
