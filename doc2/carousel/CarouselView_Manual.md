# CarouselView Usage Manual

This manual introduces the usage of `BannerCarouselView` as implemented in `CarouselView.swift`. It covers all demonstrated cases, configuration options, event handling, and best practices for integrating carousel banner ads in your iOS application.

---

## 1. Overview

`BannerCarouselView` enables the display of multiple banner ads in a horizontal carousel format. It supports flexible configuration, advanced targeting, custom UI decoration, and robust event handling.

---

## 2. Basic Configuration

Create a carousel view and load multiple banners:

```swift
let carouselView = BannerCarouselView()
let adRequest = AdRequest(adSpotList: [
    .init(adSpotId: "ad_spot_id_1"),
    .init(adSpotId: "ad_spot_id_2"),
    .init(adSpotId: "ad_spot_id_3"),
])
carouselView.load(adRequest: adRequest, eventHandler: eventHandler)
```

---

## 3. Advanced Configuration

Pass additional targeting parameters and an `easyId`:

```swift
let carouselView = BannerCarouselView()
let adRequest = AdRequest(adSpotList: [
    .init(adSpotId: "ad_spot_id_1", properties: ["age": 25]),
    .init(adSpotId: "ad_spot_id_2", genre: .init(masterId: 123, code: "code", match: "iOS")),
    .init(adSpotId: "ad_spot_id_3", customTargeting: ["key1": ["value1"], "key2": ["value2"]]),
], easyId: "easy_id_123")
carouselView.load(adRequest: adRequest, eventHandler: eventHandler)
```

---

## 4. Fixed Item Width

Set a fixed width for carousel items:

```swift
let carouselView = BannerCarouselView()
carouselView.itemScaleMode = .fixed(itemWidth: 50)
let adRequest = AdRequest(adSpotList: [
    .init(adSpotId: "ad_spot_id_1"),
    .init(adSpotId: "ad_spot_id_2"),
    .init(adSpotId: "ad_spot_id_3"),
])
carouselView.load(adRequest: adRequest, eventHandler: eventHandler)
```

---

## 5. Custom UI Decoration

Customize the appearance of each banner in the carousel:

```swift
let carouselView = BannerCarouselView()
carouselView.decorator = { banner, position in
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    container.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    container.addSubview(banner)
    container.backgroundColor = UIColor.lightGray
    container.layer.borderColor = UIColor.blue.cgColor
    container.layer.borderWidth = 2.0
    container.layer.cornerRadius = 8.0
    return banner
}
let adRequest = AdRequest(adSpotList: [
    .init(adSpotId: "ad_spot_id_1"),
    .init(adSpotId: "ad_spot_id_2"),
    .init(adSpotId: "ad_spot_id_3"),
])
carouselView.load(adRequest: adRequest, eventHandler: eventHandler)
```

---

## 6. Event Handling

Implement an event handler to respond to ad events:

```swift
private func eventHandler(carouselView: BannerCarouselView, bannerView: BannerView?, adEvent: AdEvent) {
    switch adEvent {
    case .success:
        print("Banner(\(bannerView?.adSpot?.adSpotId ?? "unknown")) loaded successfully in carousel")
    case .failed(let err):
        print("Banner(\(bannerView?.adSpot?.adSpotId ?? "unknown")) failed to load in carousel with error: \(err)")
    case .groupFinished:
        print("Carousel group finished loading despite some banners may have failed")
        if carouselView.itemCount > 0 {
            self.view.addSubview(carouselView)
        }
    case .groupFailed(let err):
        print("Carousel group failed to load with error: \(err)")
    default:
        print("Received ad event: \(adEvent)")
    }
}
```

### Event Types
- `.success`: Banner loaded successfully.
- `.failed(let error)`: Banner failed to load.
- `.groupFinished`: All banners finished loading (some may have failed).
- `.groupFailed(let error)`: The group failed to load entirely.
- Other events: Handle as needed.

---

## 7. Best Practices

- Always add the carousel view to your view hierarchy after banners are loaded.
- Use unique ad spot IDs for each banner.
- Customize the UI for better user experience.
- Handle both individual and group-level failures.

---

## 8. Troubleshooting

- Ensure all ad spot IDs are valid and active.
- Check network connectivity if banners fail to load.
- Review error messages in the event handler for diagnostics.

---

## 9. References

- [RUNABanner SDK Documentation](#)
- [SampleCode/CarouselView.swift](./CarouselView.swift)

For further assistance, refer to the official SDK documentation or contact support.
