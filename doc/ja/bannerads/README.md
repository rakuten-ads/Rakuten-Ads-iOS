[TOP](../#top)　>　バナー広告

---

# バナー広告

RUNA SDK banner view は `WebKit/WKWebView`を元にした web view です。Web 広告タグをロードして広告内容を表示しています。

---

## 1. 設定項目

### AdSpotId

`Ad Spot`は広告表示枠を意味するもので、`adSpotId`はその枠のユニークな ID を定義するものです。その ID は広告内容を要求する時に必要なパラメーターです。パブリッシャー管理サイドに登録及び検索できます。

### AdSpotCode

`Ad Spot code`は`adSpotId`の可読性のある名前です。ユーザーがパブリッシャー管理サイドに`adSpotId`に対して自分で指定できます。

### サイズ

**size** プロパーティーに三つのサイズ調整設定が出来ます。

- `default` :<br>
黙認値。`adspotId`を登録時にサーバーサイドで設定したサイズを反映します。サイズ指定が無効となります

- `aspectFit` : <br>
縦横比率を保つづ、親Viewの横サイズを充満するまでアウトレイアウトで伸縮します。

- `custom` :<br>
任意のサイズを指定します。

### osition

画面の任意の場所に指定できます。また、SDKが **position** プロパーティーにいくつの便利な設定項目を用意しています。

- `custom` :<br>
黙認値。 `frame.origin` の場所に配置します。

- `top` :<br>
親Viewの中央上寄せする。

- `topLeft` :<br>
親Viewの左上寄せする。

- `topRight` :<br>
親Viewの右上寄せする。

- `bottom` :<br>
親Viewの中央下寄せする。

- `bottomLeft` :<br>
親Viewの左下寄せする。

- `bottomRight` :<br>
親Viewの右下寄せする。

### Event Tracker

RUNA SDK は三つのイベントをトラッキングすることが可能です。

- **成功 (RUNABannerViewEventTypeSucceeded) :**
  広告内容の受信完了

- **失敗 (RUNABannerViewEventTypeFailed) :**
  広告内容のリクエストのそう受信、及び広告表示のいずれかで失敗した場合。<br>
　失敗の原因は `RUNABannerViewError` プロパーティーとシステムログで確認することができます。
  - `none` : エラーなし。
  - `internal` : 予想外のSDK内部エラーUnexpected internal error of SDK。
  - `network` : 通信エラー。
  - `fatal` : パラメーターの設定ミス。
  - `unfilled` : 表示できる広告がない。

- **クリック (RUNABannerViewEventTypeClicked) :**
  banner 広告がクリックされた。この時参照できるプロパティーは以下です。
  - `clickURL` : <br>
  広告を開くリンク。
  - `shouldPreventDefaultClickAction` : <br>
  デフォルトは `false`. `true`の場合、SDKがシステムブラウザ使って広告を開く動きを止めます。

### Open Measurement

Open Measurementを自動に有効するために`Podfile`に `pod 'OMAdapter'`を追加する必要があります。
尚、`banner.disableOpenMeasurement` APIを使って個別なbannerを無効することも可能性す。

### Ad Sesssion

`RUNAAdSession` は広告内容の重複排除するために使用されます。`RUNAAdSession`が設定され且つnilではない場合、同じセッションに異なる広告内容がロードされることは保証されます。

> __注意：__ 二つのバナーのロードタイミングが近い場合、重複な広告が表示されてしまう可能性があります。

### 拡張設定

参照先: [拡張モジュール](./extension/README.md)

### バナーグループ設定

一回複数異なる広告内容をリクエストします。
参照先: [バナーグループ](./group/README.md)

Group Requestを利用するUI 部品。
参照先: [Carousel View](./carousel/README.md)


## 2. 実装サンプル

### 一般の実装
![Language](http://img.shields.io/badge/language-ObjctiveC-red.svg?style=flat)

```objc
#import <RUNA/RUNA.h>
#import <RUNAOMAdapter/RUNAOMAdapter.h> // if need disable open measurement

RUNABannerView* banner = [RUNABannerView new];

banner.adSpotId = @"spot_id_xxx";
banner.position = RUNABannerViewPositionBottom;

// specify disable open measurement by need
// [banner disableOpenMeasurement];

[banner loadWithEventHandler:^(RUNABannerView * _Nonnull view, struct RUNABannerViewEvent event) {
    switch (event.eventType) {
        case RUNABannerViewEventTypeSucceeded:
            NSLog(@"received event succeeded");
            [banner setCenter:[self.view center]];
            break;
        case RUNABannerViewEventTypeFailed:
            NSLog(@"received event failed");
            switch (event.error) {
                case RUNABannerViewErrorUnfilled:
                    NSLog(@"ad unavailable");
                    break;
                case RUNABannerViewErrorNetwork:
                    NSLog(@"network unavailable");
                    break;
                default:
                    break;
            }
            break;
        case RUNABannerViewEventTypeClicked:
            NSLog(@"received event clicked");
            if (view.clickURL != nil) {
                view.shouldPreventDefaultClickAction = YES;
                print("do something with the click url by self")
            }
            break;
        default:
            NSLog(@"unknown event");
            break;
    }
}];
[self.view addSubview:banner];
```

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift
import RUNABanner
import RUNAOMAdapter // if need disable open measurement

let banner = RUNABannerView()

banner.adSpotId = "0000"
banner.position = .bottom

// specify disable open measurement by need
// banner.disableOpenMeasurement()

banner.load { (view, event) in
    switch event.eventType {
    case .succeeded:
        print("received event succeeded")
    case .failed:
        print("received event failed")
        switch event.error {
        case .unfilled:
            print("ad unavailable")
        case .network:
            print("network unavailable")
        default:
            break
        }
    case .clicked:
        print("received event clicked")
        if let url = view.clickURL {
            view.shouldPreventDefaultClickAction = true
            print("do something with the click url by self")
        }
    default:
        break
    }
}

self.view.addSubview(banner)
```

### 広告内容の重複排除

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift
// 生存期間に管理されたオブジェクトを作成します
private let adSession = RUNAAdSession()

...

// 最初のバナーをロードさせます
banner1.session = adSession
banner1.load()

...

// 時間少し間隔を空けるように意識しながら次のバナーをロードさせます
banner2.session = adSession
banner2.load()
```

### AdSpotCodeを使用する

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift
import RUNABanner

let banner = RUNABannerView()

banner.adSpotCode = "mycode"
banner.size = .aspectFit
banner.position = .bottom

banner.load { (view, event) in
    switch event.eventType {
    case .succeeded:
        print("received event succeeded")
    case .failed:
        print("received event failed")
        switch event.error {
        case .unfilled:
            print("ad unavailable")
        case .network:
            print("network unavailable")
        default:
            break
        }
    case .clicked:
        print("received event clicked")
    default:
        break
    }
}

self.view.addSubview(banner)
```

### SwiftUI の拡張例

参照 [Sample Code](../../resources/ContentView.swift)

---

[TOP](../#top)

---

LANGUAGE :

> [![en](/doc/lang/en.png)](/doc/bannerads/README.md)
