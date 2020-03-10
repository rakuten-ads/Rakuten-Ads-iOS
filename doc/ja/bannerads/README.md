[TOP](../#top)　>　バナー広告

---

# バナー広告

RDNSDK banner view は `WebKit/WKWebView`を元にした web view です。Web 広告タグをロードして広告内容を表示しています。

---

## 1. 設定項目

### 1.1 AdSpotId

`Ad Spot`は広告表示枠を意味するもので、`adSpotId`はその枠のユニークな ID を定義するものです。その ID は広告内容を要求する時に必要なパラメーターです。パブリッシャー管理サイドに登録及び検索できます。

### 1.2 サイズと位置

Banner View のサイズはプログラムで指定することが調整出来ません。管理画面で`adspotId`を登録する同時に指定することになります。なお、場所を任意に指定することが出来ます。SDK も便利のためいくつの場所設定値を用意しています。

### 1.3 Event Tracker

RDNSDK は三つのイベントをトラッキングすることが可能です。

#### 1.3.1 イベント

- **成功 (RUNABannerViewEventSucceeded) :**
  広告内容の受信完了

- **失敗 (RUNABannerViewEventFailed) :**
  広告内容のリクエストのそう受信、及び広告表示のいずれかで失敗した場合。<br>失敗の原因はシステムログで確認することができます。

- **クリック (RUNABannerViewEventClicked) :**
  banner 広告がクリックされた時。

## 2. 実装サンプル

![Language](http://img.shields.io/badge/language-ObjctiveC-red.svg?style=flat)

```objc
#import <RUNA/RUNABanner.h>

RUNABannerView* banner = [RUNABannerView new];

banner.adSpotId = @"spot_id_xxx";
banner.position = RUNABannerViewPositionBottom;

[banner loadWithEventHandler: ^void (RUNABannerView* view, RUNABannerViewEvent event){
    switch (event) {
        case RUNABannerViewEventSucceeded:
            NSLog(@"received event succeeded");
            break;
        case RUNABannerViewEventFailed:
            NSLog(@"received event failed");
            break;
        case RUNABannerViewEventClicked:
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
import RUNA

let banner = RUNABannerView()

banner.adSpotId = "adspot_id_xxx"
banner.position = .bottom

banner.load { (banner, event) in
    switch event {
    case RUNABannerViewEvent.succeeded:
        print("received event succceeded")
    case RUNABannerViewEvent.failed:
        print("received event failed")
    case RUNABannerViewEvent.clicked:
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
