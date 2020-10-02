[TOP](/README.md#top)　>　App to App

---

# App to App

## Objective

How to activate the A2A module is explained in this document.<br>
The activation of this module enables you to have new sources of revenue through new ad formats.<br>
Just in case you have a question related to the business background, please feel free to contact with our sales person in charge.

`RUNA/A2A` is extension for `RUNA/Banner`, the all configurations and method of `RUNA/Banner` are supported to `RUNA/A2A`.
Please [see it](/doc/bannerads/README.md#Banner_Ads)

--

## Integrate SDK

### CocoaPods
Put under lines into `Podfile`.

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

## Configurations

Please [see it](/doc/bannerads/README.md#1-configurations)

### AppContent
Either parameter is nullable, but at least one is not null.

- `title`:<br>
Title shows in the popup advertise items list view.

- `keyword`:<br>
Keywords relate the advertise content, delimited by comma `,`.

- `url`:<br>
Indicate URL to show a specific advertise content.


### Sample

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
[TOP](/README.md#top)

---
LANGUAGE :
> [![ja](/doc/lang/ja.png)](/doc/ja/a2a/README.md)
