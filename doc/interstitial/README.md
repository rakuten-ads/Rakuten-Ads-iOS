[TOP](/README.md#top)　>　 Interstitial Ads

---

# Interstitial Ads

`RUNAInterstitialAd` is an interface based on a `RUNABannerView` banner helps app to show a full-screen interstitial ad.

---

## How to use

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
 
 - `RUNAInterstitialAdSizeFullScreen`: ad content shown in full screen

__BOOL hideStatusBar__

The `hideStatusBar` property controls the visibility of the status bar when the interstitial ad is displayed.

 - `true`: The status bar will be hidden during the interstitial ad display for a full immersive experience.

 - `false`: The status bar remains visible during the interstitial ad display.


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
