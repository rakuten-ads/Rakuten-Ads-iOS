# VideoAdView

`VideoAdView` is a UIView subclass that renders VAST 4.0 video ads inside a WebKit-based player. It handles video loading, viewability measurement, impression/in-view tracking, and playback control automatically.

---

## Requirements

- iOS 15.6+
- Swift 6.1+
- `RUNABanner` framework (which depends on `RUNACore`)
- A valid VAST 4.0 XML string

---

## Overview

```
VideoAdView
├── Displays a VAST 4.0 video ad in an embedded web player
├── Fires impression and in-view tracking URLs automatically
├── Auto-pauses/resumes based on view visibility
└── Reports lifecycle events via a callback closure
```

---

## Quick Start

```swift
import RUNABanner

let videoAdView = VideoAdView(frame: CGRect(x: 0, y: 0, width: 320, height: 180))
view.addSubview(videoAdView)

let adContent = AdContent(
    vastXml: "<VAST ...>...</VAST>",
    impressionURL: "https://example.com/impression",
    inviewURL: "https://example.com/inview"
)

videoAdView.load(adContent: adContent) { adView, event in
    switch event {
    case .success:
        print("Video ad loaded")
    case .failed(let err):
        print("Failed: \(err)")
    case .clicked(let url):
        print("Ad clicked: \(url)")
    default:
        break
    }
}
```

---

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| `shouldPreventDefaultClickAction` | `Bool` | `false` | When `true`, suppresses the automatic `UIApplication.open(_:)` call on ad click. Use this when you want to handle navigation yourself inside the `.clicked(url:)` event. |
| `disableBorderAdjustment` | `Bool` | `false` | When `true`, disables safe-area border adjustments applied to the inner web view. |
| `enableSystemFontScaling` | `Bool` | `false` | When `true`, allows the system text-size setting (Dynamic Type) to scale content inside the ad web view. |

---

## Methods

### `load(adContent:eventHandler:)`

```swift
public func load(
    adContent: AdContent,
    eventHandler: @escaping (VideoAdView, AdEvent) -> Void
)
```

Loads and displays the video ad described by `adContent`. Set all configuration properties before calling this method. Calling `load` again on an already-loaded view resets all internal state and starts a fresh load — you do not need to create a new instance.

**Parameters**

| Parameter | Type | Description |
|---|---|---|
| `adContent` | `AdContent` | The ad data to render. Must contain a non-empty `vastXml` string. |
| `eventHandler` | `(VideoAdView, AdEvent) -> Void` | Called once per lifecycle event. Always called on the main thread. |

---

### `toggleVideoAdPlay(shouldPlay:)`

```swift
public func toggleVideoAdPlay(shouldPlay: Bool)
```

Manually controls playback. Pass `true` to resume, `false` to stop. The SDK controls playback automatically based on in-view visibility, but you can use it to sync with your app's lifecycle (e.g., resume on didBecomeActiveNotification).

---

## AdContent

```swift
public struct AdContent {
    public let vastXml: String        // Required — VAST 4.0 XML string
    public let impressionURL: String? // Fired when the ad is measured as viewable
    public let inviewURL: String?     // Fired when the ad enters the viewport

    public init(
        vastXml: String,
        impressionURL: String? = nil,
        inviewURL: String? = nil
    )
}
```

---

## AdEvent

The event handler receives one of the following cases:

| Case | When fired |
|---|---|
| `.success` | The video player has fully initialised and playback is ready. |
| `.failed(err: AdError)` | Loading failed at any stage. No further events will be sent. |
| `.clicked(url: String)` | The user tapped the ad. `url` is the destination URL. |

> `VideoAdView` only emits `.success`, `.failed`, and `.clicked`. The remaining `AdEvent` cases (`.groupFailed`, `.groupFinished`, `.interstitialClosed`) are not used by this component.

### AdError values

| Case | Meaning |
|---|---|
| `.sdkNotReady` | `vastXml` was empty or another unrecoverable pre-load error occurred. |
| `.network` | The template or web view navigation request failed. |
| `.internalError(msg:)` | An unexpected internal error; `msg` contains details. |

---

## Viewability & Tracking

`VideoAdView` starts viewability measurement automatically once the VAST player signals it has loaded. No additional configuration is required.

- **Impression URL** — fired once the view is loaded and initially visible.
- **In-view URL** — fired once the view has been continuously visible for 2 seconds, conforming to the MRC standard.
- **Auto-pause / resume** — the video player plays when the view is in-view and pauses when it scrolls out. Call `toggleVideoAdPlay(_:)` to override this, for example on `applicationDidBecomeActive`.

---

## Click Handling

By default, tapping the ad opens the click-through URL in Safari via `UIApplication.open`. To suppress this and handle navigation yourself:

```swift
videoAdView.shouldPreventDefaultClickAction = true

videoAdView.load(adContent: adContent) { adView, event in
    if case .clicked(let url) = event {
        // open url your own way
    }
}
```

---

## Lifecycle Notes

- Calling `load` while a previous load is in progress cancels the in-flight network task and restarts.
- When `VideoAdView` is deallocated, all measurement tasks and the web view's script message handlers are cleaned up automatically.
- The `eventHandler` closure is guaranteed to fire **at most once** per `load` call for terminal events (`.success`, `.failed`).

---

## Implementation Sample (Swift)

### Minimal — load and display

```swift
import UIKit
import RUNABanner

class MyViewController: UIViewController {

    private let videoAdView = RUNAVideoAdView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoAdView()
        loadAd()
    }

    private func setupVideoAdView() {
        view.addSubview(videoAdView)
        videoAdView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoAdView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoAdView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoAdView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoAdView.heightAnchor.constraint(equalToConstant: 180),
        ])
    }

    private func loadAd() {
        let adContent = AdContent(
            vastXml: "<VAST ...>...</VAST>",
            impressionURL: "https://example.com/impression",
            inviewURL: "https://example.com/inview"
        )

        videoAdView.load(adContent: adContent) { adView, event in
            switch event {
                case .success:
                    print("Video ad loaded")
                case .failed(let err):
                    print("Failed: \(err)")
                case .clicked(let url):
                    print("Ad clicked: \(url)")
                default:
                    break
            }
        }
    }
}
```

### Full — with tracking URLs, custom click handling, and app lifecycle

```swift
import UIKit
import RUNABanner
import SafariServices

class VideoAdViewController: UIViewController {

    private let videoAdView = RUNAVideoAdView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideoAdView()
        fetchAndLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func appDidBecomeActive() {
        videoAdView.toggleVideoAdPlay(true)
    }

    private func configureVideoAdView() {
        // Intercept clicks — open in an in-app browser instead of Safari
        videoAdView.shouldPreventDefaultClickAction = true
        // Respect the user's preferred text size
        videoAdView.enableSystemFontScaling = true

        view.addSubview(videoAdView)
        videoAdView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoAdView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoAdView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoAdView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            videoAdView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }

    // Example: fetch VAST XML from the RUNA RTB API, then load
    private func fetchAndLoad() {
        let postBody: [String: Any] = [
            "imp": [[
                "banner": ["api": [7]],
                "ext": [
                    "adspot_id": "<YOUR_ADSPOT_ID>",
                    "json": ["targeting": ["kw": ["<YOUR_KEYWORD>"]]]
                ]
            ]]
        ]

        var request = URLRequest(url: URL(string: "<RUNA_ENDPOINT>")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: postBody)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let bid = (json["seatbid"] as? [[String: Any]])?.first?["bid"]
                             .flatMap({ $0 as? [[String: Any]] })?.first,
                  let ext = bid["ext"] as? [String: Any],
                  let vastXml = ext["vast_xml"] as? String else { return }

            let adContent = RUNAAdContent(vastXml: vastXml)
            adContent.impURL    = ext["impression_url"] as? String
            adContent.inviewURL = ext["inview_url"] as? String

            DispatchQueue.main.async {
                self?.load(adContent: adContent)
            }
        }.resume()
    }

    private func load(adContent: RUNAAdContent) {
        videoAdView.load(adContent: adContent) { [weak self] adView, event in
            guard let self else { return }
            switch event.eventType {
            case .succeeded:
                print("Video ad loaded")

            case .failed:
                print("Video ad failed: error=\(event.error.rawValue)")

            case .clicked(let clickUrl):
                guard videoAdView.shouldPreventDefaultClickAction,
                      let url = URL(string: clickUrl) else { return }
                let safari = SFSafariViewController(url: url)
                safari.modalPresentationStyle = .pageSheet
                safari.delegate = self
                self.present(safari, animated: true)

            default:
                break
            }
        }
    }
}

extension VideoAdViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        videoAdView.toggleVideoAdPlay(true)
    }
}
```

---

## References
- [RUNA SDK API Documentation](https://rakuten-ads.github.io/runasdk.github.io/)

For further assistance, rise a Github issue or contact support.
