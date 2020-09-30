[TOP](/README.md#top)　>　App to App

---

# App to App

## 目的

本稿では、A2Aモジュールを有効化する手順を説明します。<br>
A2Aモジュールは、その柔軟な広告フォーマットを通じて、新たな収益源を獲得することが可能となります。<br>
なお、つなぎこみのビジネス的背景に関するご質問は、営業担当宛てにお願い致します。


`RUNA/A2A` は `RUNA/Banner`の拡張モデルとして, `RUNA/Banner`の設定と機能全部使用できます。
Please [see it](/ja/bannerads/README.md#Banner_Ads)

--

## SDK導入

### CocoaPods
`Podfile`に下記の設定を追加.

```ruby
source "https://github.com/rakuten-ads/Rakuten-Ads-iOS"

pod 'RUNA/A2A'
```

### import module

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```Swift
import RUNAA2A
```

![Language](http://img.shields.io/badge/language-ObjctiveC-red.svg?style=flat)
```Objc
import <RUNAA2A/RUNAA2A.h>
```

## 設定項目

Please [see it](/bannerads/README.md#1._Configurations)

### AppContent
何のパラメーターはnull値が可能ですが、最少一つはnullじゃなければなりません。

- `title`:<br>
飛び出す広告アイテムリスト画面のタイル

- `keyword`:<br>
広告内容に関連する`,`区切りのキーワードリストです。

- `url`:<br>
特定の広告内容を指定するURLです


### 実装例

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift

let banner = RUNABannerView()

banner.adSpotId = "0000"
banner.position = .bottom
banner.size = .aspectFit

let appContent = RUNABannerViewAppContent(title: "title", keywords: "keywords", url: "url")
bannerView.setBannerViewAppContent(appContent)

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

![Language](http://img.shields.io/badge/language-ObjctiveC-red.svg?style=flat)

```objc
#import <RUNABanner/RUNABanner.h>
#import <RUNAA2A/RUNAA2A.h>

RUNABannerView* banner = [RUNABannerView new];

banner.adSpotId = @"0000";
banner.position = RUNABannerViewPositionBottom;
banner.size = RUNABannerViewSizeAspectFit;

RUNABannerViewAppContent* appContent = [[RUNABannerViewAppContent alloc] initWithTitle:nil keywords:"macbook" url:nil];
[banner setBannerViewAppContent:appContent];

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

<br><br><br><br><br>
---
[TOP](../#top)

---
LANGUAGE :
> [![en](/doc/lang/en.png)](/doc/a2a/README.md)
