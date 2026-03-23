# BannerSwiftUI Usage Manual

This document provides a comprehensive guide for integrating and using banner ads in SwiftUI via the RUNABanner framework, based on the implementation in `BannerSwiftUI.swift`.

---

## 1. Overview

`BannerSwiftUI.swift` demonstrates how to display a banner ad in a SwiftUI view by bridging UIKit's `BannerView` using `UIViewRepresentable`.

---

## 2. Key Components

### ContainerView
A SwiftUI view that displays a banner ad:

```swift
struct ContainerView: View {
    var body: some View {
        VStack {
            Text("Banner in SwiftUI")
            BannerViewRepresentable(adRequest: .init(adSpot: .init(adSpotId: "ADSPOT_ID_HERE")))
                .frame(width: 320, height: 50)
        }
    }
}
```

### BannerViewRepresentable
A `UIViewRepresentable` wrapper for `BannerView`:

```swift
struct BannerViewRepresentable: UIViewRepresentable {
    let adRequest: AdRequest

    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView()
        bannerView.load(adRequest: adRequest) { banner, event in
            switch event {
            case .success:
                print("BannerViewRepresentable Success")
            case .failed(let error):
                print("BannerViewRepresentable Failed: \(error)")
            case .clicked:
                print("BannerViewRepresentable Clicked")
            default:
                break
            }
        }
        return bannerView
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        print("updateUIView - Banner NOT recreated")
    }
}
```

---

## 3. Usage Steps

### Step 1: Import Required Modules

```swift
import SwiftUI
import RUNABanner
```

### Step 2: Create an AdRequest

```swift
let adRequest = AdRequest(adSpot: .init(adSpotId: "ADSPOT_ID_HERE"))
```

### Step 3: Use BannerViewRepresentable in Your SwiftUI View

```swift
BannerViewRepresentable(adRequest: adRequest)
    .frame(width: 320, height: 50)
```

---

## 4. Event Handling

Events are handled in the `load` callback:
- `.success`: Banner loaded successfully.
- `.failed(let error)`: Banner failed to load. Error details are printed.
- `.clicked`: Banner was clicked.
- Other events: Ignored in this implementation.

---

## 5. Notes & Best Practices

- Always provide a valid ad spot ID in `AdRequest`.
- Set the frame size to match the expected banner dimensions (e.g., 320x50).
- The banner view is created once; `updateUIView` does not recreate it, ensuring efficient updates.
- Handle all relevant events for robust user experience.

---

## 6. Example: Complete Integration

```swift
struct ContentView: View {
    var body: some View {
        BannerViewRepresentable(adRequest: .init(adSpot: .init(adSpotId: <YOUR_ADSPOT_ID>)))
            .frame(width: 320, height: 50)
    }
}
```

---

## 7. Troubleshooting

- Ensure the ad spot ID is correct and active.
- Check for network connectivity if the banner fails to load.
- Review console output for error details.

---

## 8. References

- [RUNA SDK API Documentation](https://rakuten-ads.github.io/runasdk.github.io/iOS/)

For further assistance, rise a Github issue or contact support.
