[TOP](/README.md#top)　>　 Mediation Adapter

---

# MediationAdapter

The module `MediationAdapter` is an SDK to connect with the mediation function of other SDK products.
Currently we have the support for `GADBanner` feature of `GoogleAdsMobile` SDK.

---

## How to Use

- User has an admob account

- Set up a mediation group by adding ad custom event and mapping the custom event with class name `GADMediationAdapterRunaCustomEvent`.

- Follow the instruction of Google Ad Mobile to import `GoogleAdsMobile` SDK and implement the GADBanner

- Follow the instruction here to import `RUNAMediationAdapter` and implement the essential parameters for `RUNAMediationAdapter`

## [Integrate SDK](#integrate-sdk)

### [CocoaPods](#cocoapods)
Edit the Podfile to contains the following configuration.

```ruby
source "https://github.com/rakuten-ads/Rakuten-Ads-iOS"

pod 'RUNA/MediationAdapter'
```

### [Swift Package Manager](#spm)

`MediationAdapter` is supported from `1.16.0`,

So please add package from URL `https://github.com/rakuten-ads/Rakuten-Ads-iOS` in Xcode,
and select `RUNAMediationAdapter` to target project.

The `MediationAdapter` SDK is dependent on `GoogleAdsMobile` SDK, but the SPM is not recommanded by `GoogleAdsMobile`.
So `RUNAMediationAdapter` doesn't declare the dependency relation while let user to decide the method to import `GoogleAdsMobile` SDK.

## How to cooperate with `GoogleAdsMobile`

1. Make sure `GoogleAdsMobile` has been added to the dependencies or build paths.

2. Implement with the Googel Ad banner.

2. Add essential parameters for RUNA ad


The following steps complete showing an interstitial ad:

1. [Configuration](#configuration)
2. [Preload ad content](#preload-ad-content)
3. [Show ad](#show-ad)

### Configuration

#### Basic properties

- adSpotId
- adSpotCode

Either `adSpotId` or `adSpotCode` is required to identify the remote ad configuration when not indicate property `adContentView`. It can be reached or registerred on the publisher admin site.

#### Advanced properties

__RUNAInterstitialAdSize size__

The `size` property provides 3 options to scale the ad content:

 - `RUNAInterstitialAdSizeAspectFit`: auto resize ad with a fixed aspect radio to fit the screen in horizontal or vertical direction.

 - `RUNAInterstitialAdSizeOriginal`: keep the original size of the creative.

 - `RUNAInterstitialAdSizeCustom`: customize support to let app set the layout constraints with a `RUNAInterstitialAdCustomDecorator`.

__RUNAInterstitialAdCustomDecorator decorator__

`typedef void (^RUNAInterstitialAdCustomDecorator)(UIView* const containerView, UIView* const adView, UIImageView* const closeButton);`

A callback block to set the auto layout constraints with provided 3 parameters, the container view, the ad view and the close button. For the purpose like specifications of padding, position, color, and so on.

__UIImage preferredCloseButtonImage__

Change to the appearance of the close button view by a preferred image.

__RUNABannerView adContentView__

Provide a `RUNABannerView` instance to apply the complex propeties such as targeting and cooperation ids. But the `size` and `position` properties will be igored as `RUNAInterstitialAd` is more priority.
 
### Preload ad content

`-(void) preloadWithEventHandler:(nullable void (^)(RUNAInterstitialAd* adView, struct RUNABannerViewEvent event)) handler;`

This api prepares the ad content by sending an request to server. It accepts a parameter of callback block to handle various events.

__RUNAInterstitialAd__

The instance of `RUNAInterstitialAd`.

__RUNABannerViewEvent__

Beside the events of `RUNABannerView` ([see here](../bannerads/README.md/#event-tracker)), `RUNAInterstitialAd` tracks a new event `RUNABannerViewEventTypeInterstitialClosed` to offer a custom process after closing the interstitial ad.

When receiving `RUNABannerViewEventTypeSucceeded` event, the readonly property `loadSucceeded` is set to `true`.

### Show ad

`-(BOOL)showIn:(UIViewController*) parentViewController`

The prameter `parentViewController` is the `UIViewController` to be covered and the return value is set to `true` when the interstitial ads showed successfully.

## Samples

### Normal case
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift
// ... preload
let interstitialAd = RUNAInterstitialAd()
self.interstitialAd = interstitialAd // retain instance
interstitialAd.adSpotId = "adspot id"
interstitialAd.preload()

// ... show
if let interstitialAd = self.interstitialAd,
    interstitialAd.show(in: parentViewController) {
    // ad showed
} else {
    // ad is not ready, go next
}
```

### Case of complex banner configuration
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift
// ... preload
let interstitialAd = RUNAInterstitialAd()
self.interstitialAd = interstitialAd // retain instance
let banner = RUNABannerView()
banner.adSpotid = "an adspot id"
banner.setCustomTargeting(targetingValues)
banner.setRz("a RzCookie")

interstitialAd.adContentView = banner
interstitialAd.preload()

// ... show
if let interstitialAd = self.interstitialAd,
    interstitialAd.show(in: parentViewController) {
    // ad showed
} else {
    // ad is not ready, go next
}
```

### Case of custom UI
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift
// ... preload
let interstitialAd = RUNAInterstitialAd()
self.interstitialAd = interstitialAd // retain instance
interstitialAd.adSpotId = "an adspot id"
interstitialAd.preferredCloseButtonImage = UIImage(named: "a close image")
interstitialAd.decorator = { containerView, adView, closeButton in
    containerView.backgroundColor = UIColor.clear
    NSLayoutConstraint.activate([
        // ... same auto layout constraints
    ])
}

interstitialAd.preload()

// ... show
if let interstitialAd = self.interstitialAd,
    interstitialAd.show(in: parentViewController) {
    // ad showed
} else {
    // ad is not ready, go next
}
```

### Case of auto showing when ready
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift
let interstitialAd = RUNAInterstitialAd()
self.interstitialAd = interstitialAd // retain instance

interstitialAd.adSpotId = "adspot id"
interstitialAd.preload { [weak self] adView, event
    switch event.eventType {
        case .succeeded:
            if adView.show(in: self?.parentViewController) {
                // ad showed
            } else {
                // ad is not ready, go next
            }
        case .interstitialClosed:
            // ad closed
    }
}
```

---

[TOP](/README.md#top)

---

LANGUAGE :

> [![ja](/doc/lang/ja.png)](/doc/ja/interstitial/README.md)
