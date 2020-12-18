[TOP](../#top)　>　バナー広告

---

# バナー広告

RUNA SDK banner view は `WebKit/WKWebView`を元にした web view です。Web 広告タグをロードして広告内容を表示しています。

---

## 1. 設定項目

### 1.1 AdSpotId

`Ad Spot`は広告表示枠を意味するもので、`adSpotId`はその枠のユニークな ID を定義するものです。その ID は広告内容を要求する時に必要なパラメーターです。パブリッシャー管理サイドに登録及び検索できます。

### 1.2 サイズ

**size** プロパーティーに三つのサイズ調整設定が出来ます。

- `default` :<br>
黙認値。`adspotId`を登録時にサーバーサイドで設定したサイズを反映します。サイズ指定が無効となります

- `aspectFit` : <br>
縦横比率を保つづ、親Viewの横サイズを充満するまでアウトレイアウトで伸縮します。

- `custom` :<br>
任意のサイズを指定します。

### 1.3 Position

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

### 1.4 Event Tracker

RUNA SDK は三つのイベントをトラッキングすることが可能です。

- **成功 (RUNABannerViewEventTypeSucceeded) :**
  広告内容の受信完了

- **失敗 (RUNABannerViewEventTypeFailed) :**
  広告内容のリクエストのそう受信、及び広告表示のいずれかで失敗した場合。<br>
　失敗の原因は `RUNABannerViewError` プロパーティーとシステムログで確認することができます。
  - `none` : エラーなし.
  - `internal` : 予想外のSDK内部エラーUnexpected internal error of SDK.
  - `network` : 通信エラー.
  - `fatal` : パラメーターの設定ミス.
  - `unfilled` : 表示できる広告がない.

- **クリック (RUNABannerViewEventTypeClicked) :**
  banner 広告がクリックされた時。

### 1.5 Open Measurement

Open Measurementを自動に有効するために`Podfile`に `pod 'OMAdapter'`を追加する必要があります。
尚、`banner.disableOpenMeasurement` APIを使って個別なbannerを無効することも可能性す。

### 1.6 拡張設定

参照先: [拡張モジュール](./extension/README.md)

## 2. 実装サンプル

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

banner.load { (banner, event) in
    switch event.eventType {
    case .succeeded:
        print("received event succceeded")
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

---

[TOP](../#top)

---

LANGUAGE :

> [![en](/doc/lang/en.png)](/doc/bannerads/README.md)
