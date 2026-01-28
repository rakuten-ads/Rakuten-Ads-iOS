# RUNABanner Framework Usage Manual

This manual provides a comprehensive guide for integrating and using the RUNABanner framework in your iOS application. It covers setup, initialization, banner configuration, event handling, and advanced usage scenarios based on the sample code provided.

---

## 1. Framework Integration

### Importing the Framework
Add the following import statement to your Swift files where you use banner ads:

```swift
import RUNABanner
```

Ensure RUNABanner is included in your project dependencies (via CocoaPods, Carthage, or Swift Package Manager).

---

## 2. BannerView Initialization

Create a `BannerView` instance and add it to your view hierarchy:

```swift
let bannerView = BannerView()
self.view.addSubview(bannerView)
```

You can configure its position and size:

```swift
bannerView.position = .top
bannerView.size = .aspectFit
```

---

## 3. Loading an Ad

Create an `AdRequest` with your ad spot ID and load the banner:

```swift
let request = AdRequest(adSpot: .init(adSpotId: "YOUR_ADSPOT_ID"))
bannerView.load(adRequest: request) { bannerView, adEvent in
    switch adEvent {
    case .success:
        print("Banner loaded successfully")
    case .failed(let error):
        print("Failed to load banner: \(error.localizedDescription)")
    default:
        break
    }
}
```

---

## 4. Custom Positioning

You can use Auto Layout to position the banner:

```swift
bannerView.size = .custom
bannerView.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
    bannerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20)
])
```

---

## 5. Advanced AdRequest Configuration

You can pass additional targeting information:

```swift
let request = AdRequest(adSpot: .init(adSpotCode: "YOUR_ADSPOT_CODE",
                                      properties: ["age": 25],
                                      genre: .init(masterId: 123, code: "code", match: "iOS"),
                                      customTargeting: ["key1": ["value1"], "key2": ["value2"]],
                                     ))
bannerView.load(adRequest: request) { bannerView, adEvent in
    // ...handle events...
}
```

---

## 6. Event Handling

The event handler provides feedback on ad loading and user interaction:

- `.success`: Banner loaded successfully.
- `.failed(let error)`: Banner failed to load. Handle specific error cases as needed.
- `.clicked(let url)`: User clicked the banner. URL is provided.

Example:

```swift
bannerView.load(adRequest: request) { bannerView, adEvent in
    switch adEvent {
    case .success:
        print("Banner loaded successfully")
    case .failed(let error):
        switch error {
        case .unfilled:
            print("No ad available")
        case .illegalParameter(let msg):
            print("Illegal parameter: \(msg)")
        case .sdkNotReady:
            print("SDK is not ready")
        case .network:
            print("Network error")
        case .internalError(let msg):
            print("SDK Internal error: \(msg)")
        case .outOfService:
            print("Ad service is out of service")
        case .fatal:
            print("Fatal error occurred")
        default:
            print("Other error: \(error.localizedDescription)")
        }
    case .clicked(let url):
        print("Banner clicked with URL: \(url)")
    default:
        break
    }
}
```

---

## 7. Avoiding Duplicate Ads

Use a shared `AdSession` to prevent duplicate ads in multiple banners, developer has the responsibility to maintain the life time of the `AdSession` instance:

```swift
let sharedAdSession = AdSession()
let bannerView1 = BannerView()
let bannerView2 = BannerView()
self.view.addSubview(bannerView1)
self.view.addSubview(bannerView2)

let request1 = AdRequest(adSpot: .init(adSpotId: "YOUR_ADSPOT_ID1"), session: sharedAdSession)
let request2 = AdRequest(adSpot: .init(adSpotId: "YOUR_ADSPOT_ID2"), session: sharedAdSession)

bannerView1.load(adRequest: request1, eventHandler: { bannerView, adEvent in /* ... */ })
bannerView2.load(adRequest: request2, eventHandler: { bannerView, adEvent in /* ... */ })
```

---

## 8. Best Practices

- Always add `BannerView` to your view hierarchy before loading ads.
- Use unique ad spot IDs/codes for different placements.
- Handle all error cases for robust user experience.
- Use shared `AdSession` for multiple banners to avoid duplicate ads.

---

## 9. Troubleshooting

- Ensure your ad spot ID/code is correct and active.
- Check network connectivity for ad loading.
- Review error messages in the event handler for diagnostics.

---

## 10. References
- [RUNA SDK API Documentation](https://rakuten-ads.github.io/runasdk.github.io/iOS/)

For further assistance, contact your SDK provider or refer to official documentation.
