[TOP](../README.md#top)　>　 Video Ad View

---

# RUNAVideoAdView

**RUNABanner 1.17.0** / **RUNA 1.19.0** 以降で利用可能。

`RUNAVideoAdView` は `UIView` のサブクラスで、組み込みの `WKWebView` 内に VAST 4.0 動画広告をレンダリングします。広告の読み込み、表示内計測（自動再生／自動一時停止）、インプレッションおよびインビュートラッキング、クリック処理を担います。

---

## 要件

- `RUNABanner` フレームワーク（`RUNACore` に依存）
- 有効な VAST 4.0 XML 文字列

---

## 主要クラス

### RUNAAdContent

ビューに渡す広告データを保持します。

```objc
@interface RUNAAdContent : NSObject

@property (nonatomic, copy) NSString *vastXml;              // 必須
@property (nonatomic, copy, nullable) NSString *impURL;     // 任意：インプレッショントラッキング URL
@property (nonatomic, copy, nullable) NSString *inviewURL;  // 任意：インビュートラッキング URL

- (instancetype)initWithVastXml:(NSString *)vastXml;

@end
```

`init` および `new` は使用不可 — 必ず `initWithVastXml:` を使用してください。

---

### RUNAVideoAdView

```objc
@interface RUNAVideoAdView : UIView

// ロード後は読み取り専用
@property (nonatomic, readonly) RUNAAdContent *adContent;
@property (nonatomic, readonly, nullable) NSString *clickURL;

// ロード前に設定可能
@property (nonatomic) BOOL shouldPreventDefaultClickAction;  // デフォルト: NO
@property (nonatomic) BOOL disableBorderAdjustment;          // デフォルト: NO
@property (nonatomic) BOOL enableSystemFontScaling;          // デフォルト: NO

- (void)loadAdContent:(RUNAAdContent *)adContent
     withEventHandler:(nullable void (^)(RUNAVideoAdView *_Nullable adView,
                                         struct RUNAVideoAdEvent event))handler
    NS_SWIFT_NAME(load(adContent:eventHandler:));

- (void)toggleVideoAdPlay:(BOOL)shouldPlay;

@end
```

#### プロパティ

| プロパティ | 型 | デフォルト | 説明 |
|---|---|---|---|
| `adContent` | `RUNAAdContent *`（読み取り専用） | — | ビューに読み込む基本データを持つコンテンツ。 |
| `clickURL` | `NSString *`（読み取り専用、nullable） | — | VAST 広告が報告するクリックスルー URL。`.clicked` イベント時に利用可能。 |
| `shouldPreventDefaultClickAction` | `BOOL` | `NO` | `YES` のとき、SDK はシステムブラウザで `clickURL` を開きません。イベントハンドラ経由で自前処理してください。 |
| `disableBorderAdjustment` | `BOOL` | `NO` | `YES` のとき、広告コンテンツに適用される自動ボーダーフィットを無効にします。 |
| `enableSystemFontScaling` | `BOOL` | `NO` | `YES` のとき、ビュー内の Web コンテンツがユーザーのシステムフォントサイズに合わせてスケールします。 |

#### メソッド

**`load(adContent:eventHandler:)`**

動画広告の読み込みを開始します。`eventHandler` ブロックはライフサイクルイベントごとにメインスレッドで呼び出されます。このメソッドを呼び出す前にすべての設定プロパティをセットしてください。

**`toggleVideoAdPlay(_:)`**

再生を手動で制御します。`true` で再生／再開、`false` で一時停止／停止します。SDK は表示内の可視性に基づいて自動的に呼び出しますが、アプリのライフサイクルと同期させるために使用できます（例：`didBecomeActiveNotification` での再開）。

---

### RUNAVideoAdEvent

```objc
struct RUNAVideoAdEvent {
    RUNAVideoAdEventType eventType;
    RUNAVideoAdError error;
};
```

#### RUNAVideoAdEventType

| 値 | 説明 |
|---|---|
| `.succeeded` | 広告が正常にレンダリングされました。ビューの表示準備が整っています。 |
| `.failed` | 広告が失敗しました。原因は `event.error` で確認してください。 |
| `.clicked` | ユーザーが広告をタップしました。`adView?.clickURL` にクリックスルー URL が入ります。 |

#### RUNAVideoAdError

| 値 | 説明 |
|---|---|
| `.none` | エラーなし（`.succeeded` に付随）。 |
| `.notReady` | 必須入力が不足しています — `adContent` が nil、または `vastXml` が空です。 |
| `.internal` | SDK 内部エラー。無効なリソースや不正な VAST XML など。 |
| `.network` | ネットワークリクエストまたは `WKWebView` のナビゲーションが失敗しました。 |
| `.fatal` | 回復不能な SDK 状態。 |

---

## 実装サンプル（Swift）

### 最小構成 — 読み込みと表示

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
                print("広告を読み込みました")
            case .failed:
                print("広告の読み込みに失敗しました: \(event.error)")
            case .clicked:
                print("広告がクリックされました: \(adView?.clickURL ?? "")")
            default:
                break
            }
        }
    }
}
```

### フル構成 — トラッキング URL、カスタムクリック処理、アプリライフサイクル連携

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
        // クリックを横取りして Safari の代わりにアプリ内ブラウザで開く
        videoAdView.shouldPreventDefaultClickAction = true
        // ユーザーの優先テキストサイズを尊重する
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

    // 例: RUNA RTB API から VAST XML を取得して読み込む
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
                print("動画広告を読み込みました")

            case .failed:
                print("動画広告の読み込みに失敗しました: error=\(event.error.rawValue)")

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

## 計測の動作

SDK は追加のセットアップなしに計測を自動的に管理します:

- **インプレッション** — 広告が読み込まれて最初に表示されたときに `impURL` を一度送信します。
- **インビュー** — 広告が継続して 2 秒間表示されたときに `inviewURL` を送信します（MRC 標準に準拠）。画面外に出た後に再び表示領域に入るたびに再送信します。
- **自動再生／自動一時停止** — ビューが表示領域内にあるときに動画プレーヤーが再生し、スクロールアウトすると一時停止します。`toggleVideoAdPlay(_:)` を呼び出してこの動作を上書きできます（例：`applicationDidBecomeActive` 時など）。

---

## UITableView への組み込み

`RUNAVideoAdView` は通常の `UIView` です — 他のサブビューと同様に `UITableViewCell` 内に配置してください。SDK が引き続き可視性を計測できるよう、セルとビューの両方に強参照を保持してください。

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

> ロード済みの `RUNAVideoAdView` を持つセルを `dequeueReusableCell` で再利用しないでください。広告行には毎回新たにセルを生成して直接返すことで、再利用による競合を回避できます。

---

[TOP](../README.md#top)
---

LANGUAGE :

> [![en](/doc/lang/en.png)](/doc/videoad/README.md)
