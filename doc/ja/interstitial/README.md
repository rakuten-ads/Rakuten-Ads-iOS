[TOP](../README.md#top)　>　 Interstitial Ads

---

# Interstitial Ads

`RUNAInterstitialAd` は `RUNABannerView` をベースに、アプリで全画面広告の表示を便利にするためのインターフェースです。

---

## How to use

以下の３ステップで実装されます：

1. [設定](#設定)
2. [広告を準備](#preload-ad-content)
3. [広告を表示](#show-ad)

### 設定

#### Basic properties

- adSpotId
- adSpotCode

`adContentView`が設定されていない場合、`adSpotId` 或は `adSpotCode`、いずれにサーバーに用意した広告内容を特定するため必要です。その値は管理サイトから獲得できます。

#### Advanced properties

__RUNAInterstitialAdSize size__

`size` は広告内容のサイズを決める三つのオプションを提供しています：

 - `RUNAInterstitialAdSizeAspectFit`: 横縦の比率を維持し、横縦両方向のスクリーンに自動的に適応させる

 - `RUNAInterstitialAdSizeOriginal`: 最初に決めた広告のサイズ

 - `RUNAInterstitialAdSizeCustom`: `RUNAInterstitialAdCustomDecorator`と一緒にサイズやポジションをを自由に設定させる

 - `RUNAInterstitialAdSizeFullScreen`: 全画面で広告コンテンツを表示する

__BOOL hideStatusBar__

`hideStatusBar`プロパティは、インタースティシャル広告が表示される際のステータスバーの表示・非表示を制御します。

 - `true`（デフォルト）: 完全な没入体験のため、インタースティシャル広告の表示中にステータスバーが非表示になります。

 - `false`: インタースティシャル広告の表示中もステータスバーが表示されたままになります。


__RUNAInterstitialAdCustomDecorator decorator__

`typedef void (^RUNAInterstitialAdCustomDecorator)(UIView* const containerView, UIView* const adView, UIImageView* const closeButton);`

auto layoutをサポートするコールバックです。三つのパラメータが提供される：コンテナーView、広告Viewと閉じるアイコン。独自な余白、場所、色などを指定する目的に使えます。

__UIImage preferredCloseButtonImage__

閉じるアイコンのイメージを独自に指定できる

__RUNABannerView adContentView__

ターゲッティング、連携Idなど複雑な`RUNABannerView`に設定して広告Viewとして設定させます。しかし、`RUNAInterstitialAd`を優先するため、`size` と `position`の設定が無視されます。
 
### 広告を準備

`-(void) preloadWithEventHandler:(nullable void (^)(RUNAInterstitialAd* adView, struct RUNABannerViewEvent event)) handler;`

このAPIがサーバーから広告リクエストして広告内容を用意します。様々なイベントを処理できるコールバイクが受けられます。

__RUNAInterstitialAd__

`RUNAInterstitialAd`インスタンス

__RUNABannerViewEvent__

`RUNABannerView`と同じイベントの他に([参照](../bannerads/README.md/#event-tracker))、`RUNAInterstitialAd`は新たなイベント`RUNABannerViewEventTypeInterstitialClosed`を監視し、広告を閉じる際に独自な処理をサポートしています。

イベント`RUNABannerViewEventTypeSucceeded`が来る時、読み取りプロパティ`loadSucceeded`が`true`にセットされます。

### 広告を表示

`-(BOOL)showIn:(UIViewController*) parentViewController`

`parentViewController`は覆い被さる`UIViewController`です。
広告が表示された場合戻り値が `true`に設定されます。

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

> [![en](/doc/lang/en.png)](/doc/interstitial/README.md)