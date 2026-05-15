[TOP](/README.md#top)　>　 Banner Ads

---

# RUNAVideoAdView

Available from **RUNABanner 1.17.0** / **RUNA 1.19.0**.

`RUNAVideoAdView` is a `UIView` subclass that renders a VAST 4.0 video ad inside an embedded `WKWebView`. It handles ad loading, in-view measurement (auto-play / auto-pause), impression and inview tracking, and click handling.

---

## Requirements

- `RUNABanner` framework (which depends on `RUNACore`)
- A valid VAST 4.0 XML string

---

## Key Classes

### RUNAAdContent

Carries the ad data passed to the view.

```objc
@interface RUNAAdContent : NSObject

@property (nonatomic, copy) NSString *vastXml;              // Required
@property (nonatomic, copy, nullable) NSString *impURL;     // Optional impression tracking URL
@property (nonatomic, copy, nullable) NSString *inviewURL;  // Optional inview tracking URL

- (instancetype)initWithVastXml:(NSString *)vastXml;

@end
```

`init` and `new` are unavailable — always use `initWithVastXml:`.

---

### RUNAVideoAdView

```objc
@interface RUNAVideoAdView : UIView

// Read-only after load
@property (nonatomic, readonly) RUNAAdContent *adContent;
@property (nonatomic, readonly, nullable) NSString *clickURL;

// Configurable before load
@property (nonatomic) BOOL shouldPreventDefaultClickAction;  // default: NO
@property (nonatomic) BOOL disableBorderAdjustment;          // default: NO
@property (nonatomic) BOOL enableSystemFontScaling;          // default: NO

- (void)loadAdContent:(RUNAAdContent *)adContent
     withEventHandler:(nullable void (^)(RUNAVideoAdView *_Nullable adView,
                                         struct RUNAVideoAdEvent event))handler
    NS_SWIFT_NAME(load(adContent:eventHandler:));

- (void)toggleVideoAdPlay:(BOOL)shouldPlay;

@end
```

#### Properties

| Property | Type | Default | Description |
|---|---|---|---|
| `adContent` | `RUNAAdContent *` (readonly) | — | The content with essential data to be loaded into the view. |
| `clickURL` | `NSString *` (readonly, nullable) | — | The click-through URL reported by the VAST ad. Available in the `.clicked` event. |
| `shouldPreventDefaultClickAction` | `BOOL` | `NO` | When `YES`, the SDK does not open `clickURL` in the system browser. Handle the click yourself via the event handler. |
| `disableBorderAdjustment` | `BOOL` | `NO` | When `YES`, disables the automatic border-fitting applied to ad content. |
| `enableSystemFontScaling` | `BOOL` | `NO` | When `YES`, the web content inside the view scales with the user's system font size. |

#### Methods

**`load(adContent:eventHandler:)`**

Starts loading the video ad. The `eventHandler` block is called on the main thread for each lifecycle event. Set all configuration properties before calling this method.

**`toggleVideoAdPlay(_:)`**

Manually controls playback. Pass `true` to play/resume and `false` to pause/stop. The SDK calls this automatically based on in-view visibility, but you can use it to sync with your app's lifecycle (e.g., resume on `didBecomeActiveNotification`).

---

### RUNAVideoAdEvent

```objc
struct RUNAVideoAdEvent {
    RUNAVideoAdEventType eventType;
    RUNAVideoAdError error;
};
```

#### RUNAVideoAdEventType

| Value | Description |
|---|---|
| `.succeeded` | Ad rendered successfully. The view is ready to display. |
| `.failed` | Ad failed. Check `event.error` for the reason. |
| `.clicked` | User tapped the ad. `adView?.clickURL` contains the click-through URL. |

#### RUNAVideoAdError

| Value | Description |
|---|---|
| `.none` | No error (accompanies `.succeeded`). |
| `.notReady` | Missing required input — `adContent` was nil or `vastXml` was empty. |
| `.internal` | SDK internal error, e.g. invalid resources or malformed VAST XML. |
| `.network` | Network request or `WKWebView` navigation failed. |
| `.fatal` | Unrecoverable SDK state. |

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
        let adContent = RUNAAdContent(vastXml: "<VAST version=\"4.0\">...</VAST>")

        videoAdView.load(adContent: adContent) { [weak self] adView, event in
            switch event.eventType {
            case .succeeded:
                print("Ad loaded")
            case .failed:
                print("Ad failed: \(event.error)")
            case .clicked:
                print("Ad clicked: \(adView?.clickURL ?? "")")
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

            case .clicked:
                guard videoAdView.shouldPreventDefaultClickAction,
                      let urlString = adView?.clickURL,
                      let url = URL(string: urlString) else { return }
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

## Measurement Behavior

The SDK automatically manages measurement without any additional setup:

- **Impression** — fires `impURL` once when the ad is loaded and initially visible.
- **Inview** — fires `inviewURL` when the ad has been continuously visible for 2 seconds, conforming to the MRC standard. Re-fires each time the view re-enters the viewport after being off-screen.
- **Auto-play / auto-pause** — the video player plays when the view is in-view and pauses when it scrolls out. Call `toggleVideoAdPlay(_:)` to override this, for example on `applicationDidBecomeActive`.

---

## Embedding in a UITableView

`RUNAVideoAdView` is a plain `UIView` — place it inside a `UITableViewCell` the same way as any other subview. Keep a strong reference to both the cell and the view so the SDK can continue measuring visibility.

```swift
class VideoAdCell: UITableViewCell {
    let videoAdView = RUNAVideoAdView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(videoAdView)
        videoAdView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoAdView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoAdView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            videoAdView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            videoAdView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}
```

> Do not reuse a cell that holds a loaded `RUNAVideoAdView` via `dequeueReusableCell`. Allocate the ad cell once and return it directly for the ad row to avoid reuse conflicts.

---

[TOP](/README.md#top)

---

LANGUAGE :

> [![ja](/doc/lang/ja.png)](/doc/ja/videoad/README.md)