# BannerGroup Usage Manual

This document provides a comprehensive guide for using the `BannerGroup` class from the RUNABanner framework in your iOS application. It covers initialization, configuration, event handling, and best practices, based on the provided sample code.

---

## 1. What is BannerGroup?

`BannerGroup` allows you to manage and display multiple banner ads as a group, such as in a carousel or a sequence. It simplifies loading and handling multiple ad spots with a single request and event handler.

---

## 2. Basic Usage

### Step 1: Create a BannerGroup Instance

```swift
let group = BannerGroup()
```

### Step 2: Prepare an AdRequest with Multiple Ad Spots

```swift
let adRequest = AdRequest(adSpotList: [
    .init(adSpotId: "ad_spot_id_1"),
    .init(adSpotId: "ad_spot_id_2"),
    .init(adSpotId: "ad_spot_id_3"),
])
```

### Step 3: Load the Group with the Request and Event Handler

```swift
group.load(adRequest: adRequest, eventHandler: eventHandler)
```

---

## 3. Event Handling

Implement an event handler to respond to ad events for each banner and the group as a whole:

```swift
private func eventHandler(group: BannerGroup, bannerView: BannerView?, adEvent: AdEvent) {
    switch adEvent {
    case .success:
        print("Banner(\(bannerView?.adSpot?.adSpotId ?? "unknown")) loaded successfully in carousel")
        if let bannerView = bannerView {
            self.view.addSubview(bannerView)
        }
    case .failed(let err):
        print("Banner(\(bannerView?.adSpot?.adSpotId ?? "unknown")) failed to load in carousel with error: \(err)")
    case .groupFinished:
        print("group finished loading despite some banners may have failed")
    case .groupFailed(let err):
        print("group failed to load with error: \(err)")
    default:
        print("Received ad event: \(adEvent)")
    }
}
```

### Event Types
- `.success`: A banner loaded successfully. Add the `bannerView` to your view hierarchy.
- `.failed(let error)`: A banner failed to load. Handle or log the error.
- `.groupFinished`: All banners have finished loading (some may have failed).
- `.groupFailed(let error)`: The group failed to load entirely.
- Other events: Handle as needed.

---

## 4. Best Practices

- Always add each loaded `bannerView` to your view hierarchy in the `.success` case.
- Handle both individual banner failures and group-level failures for robust error management.
- Use unique ad spot IDs for each banner in the group.
- Customize the layout and presentation of each `bannerView` as needed (e.g., in a carousel or stack).

---

## 5. Example: Complete Integration

```swift
let group = BannerGroup()
let adRequest = AdRequest(adSpotList: [
    .init(adSpotId: "ad_spot_id_1"),
    .init(adSpotId: "ad_spot_id_2"),
    .init(adSpotId: "ad_spot_id_3"),
])
group.load(adRequest: adRequest) { group, bannerView, adEvent in
    switch adEvent {
    case .success:
        if let bannerView = bannerView {
            self.view.addSubview(bannerView)
        }
    case .failed(let err):
        print("Banner failed: \(err)")
    case .groupFinished:
        print("All banners finished loading")
    case .groupFailed(let err):
        print("Group failed: \(err)")
    default:
        break
    }
}
```

---

## 6. Troubleshooting

- Ensure all ad spot IDs are valid and active.
- Check for network connectivity issues if banners fail to load.
- Review error messages in the event handler for diagnostics.

---

## 7. References

- [RUNABanner SDK Documentation](#)
- [SampleCode/BannerGroup.swift](./BannerGroup.swift)

For further assistance, refer to the official SDK documentation or contact support.
