[TOP](/README.md#top)　>　 Banner Ads

---

# Banner Ads

RUNA SDK banner view is a web view bases on `WebKit/WKWebView` which will present advertisement content by loading HTML advertisement tags.

---

## 1. Configurations

### 1.1 AdSpotID

`Ad Spot` is considerred as a placement where the advertisement is showing.`adSpotId` is the identifier of the `Ad Spot` and is required before requesting a banner ads. It can be found or registerred as a new one on the publisher management webside.

### 1.2 Size & Position

The banner view's **size** can not be changed programmatically and is depended on the configuration in the `adspotId` registration on the publisher management webside. While its **position** can be set in anywhere of the screen in demand. The SDK also has six preset position settings with the auto layout features to give some convienence during the integration.

### 1.3 Event Tracker

The RUNA SDK tracks 3 events if developers need to be triggerred and handle something by themselves.

- **Succeeded (RUNABannerViewEventSucceeded) :**<br>
  Succeeded to received the advertisement response.

- **Failed (RUNABannerViewEventFailed) :**<br>
  Failed to send, receive or show the advertisement. Detail of the failure can be found in the system console logs.

- **Clicked (RUNABannerViewEventClicked) :**<br>
  After the banner is clicked.

## 2. Samples

![Language](http://img.shields.io/badge/language-ObjctiveC-red.svg?style=flat)

```objc
#import <RUNA/RUNA.h>

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

[TOP](/README.md#top)

---

LANGUAGE :

> [![ja](/doc/lang/ja.png)](/doc/ja/bannerads/README.md)
