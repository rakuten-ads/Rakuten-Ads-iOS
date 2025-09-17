[TOP](/README.md#top)　>　 Banner Ads

---

# Banner Ads

RUNABanner SDK banner view is a web view bases on `WebKit/WKWebView` which will present advertisement content by loading HTML advertisement tags.

---

## 1. Configurations

### AdSpotId

`Ad Spot` is considerred as a placement where the advertisement is showing.`adSpotId` is the identifier of the `Ad Spot` and is required before requesting a banner ads. It can be found or registerred as a new one on the publisher management webside. `AdSpotId` is nullable when `adSpotCode` is set instead.

### AdSpotCode

`Ad Spot Code` is a readable name of `adSpotId`, is indicated by the user of admin site for any registered `adSpotId`. `AdSpotCode` is nullable when `adSpotId` is set instead.

### AdSpotBranchId

`Ad Spot Branch Id` is used to identify `Ad Spot` by individual branch ids with the same `adspotId` or `adspotCode`.
It has valid values from `RUNABannerAdSpotBranchId1` to `RUNABannerAdSpotBranchId20` of enum type `RUNABannerAdSpotBranch` and default value `RUNABannerAdSpotBranchNone`.

### Size

Then banner view has 3 options for designated **size** to support variaty of using cases.
- `default` :<br>
Default option. The banner view's **size** can not be changed programmatically and is depended on the configuration in the `adspotId` registration on the publisher management webside.
- `aspectFit` : <br>
The banner view keeps aspect radio and stretches its width to fit the super view's width.
- `custom` :<br>
The banner view can be indicated to arbitrary size and ignores the orginal size.

### disableBorderAdjustment
By default, RUNA SDK does adapt the size of some ad content with borders. 
This is will create a 1px margin edge area between ad content view and its container view.
Set property `disableBorderAdjustment` to `true` to disable this default behaviour.

### DesignatedContentSize

Readonly property `designatedContentSize` will be set by the size designated in admin site after loading ad content successfully.
It is useful for calculating the aspect ratio of the original ad content creative.

### Position

The banner view's **position** can be set in anywhere of the screen in demand. The SDK also has six preset position settings with the auto layout features to give some convienence during the integration.

- `custom` :<br>
Default option. Locate with the frame origin point.

- `top` :<br>
Locate at the top center of the super view.

- `topLeft` :<br>
Locate at the top left of the super view.

- `topRight` :<br>
Locate at the top right of the super view.

- `bottom` :<br>
Locate at the bottom center of the super view.

- `bottomLeft` :<br>
Locate at the bottom left of the super view.

- `bottomRight` :<br>
Locate at the right left of the super view.

### Event Tracker

The RUNABanner SDK tracks 3 event types of `RUNABannerViewEvent` if developers need to be triggerred and handle something by themselves.

- **Succeeded (RUNABannerViewEventTypeSucceeded) :**<br>
  Succeeded to received the advertisement response.

- **Failed (RUNABannerViewEventTypeFailed) :**<br>
  Failed to send, receive or show the advertisement. 
  
  Detail of the failure with error information can be found in RUNABannerViewError property and the system console logs. 
  - `none` : No error.
  - `internal` : Unexpected internal error of SDK.
  - `network` : Network issues.
  - `fatal` : Mistake settings.
  - `unfilled` : Request received while there is no advertisement sources to show.

- **Clicked (RUNABannerViewEventTypeClicked) :**<br>
  Event after the banner is clicked, while the following properties are available.
  - `clickURL` : <br>
  The URL directs to the advertisement.
  - `shouldPreventDefaultClickAction` : <br>
  Default `false`. `true` to prevent SDK open the click URL by the system browser.


### Open Measurement

Add `pod 'OMAdapter'` into the `Podfile` will enable open measurement feature automatically. And it could also disable this feature on a certain banner by calling api `banner.disableOpenMeasurement`.

### Ad Sesssion

`RUNAAdSession` is for avoiding duplicate advertisement contents. When a `RUNAAdSession` instance is set to banners and not nil, individual ad will be loaded at those banners with the same session instance. 

> __Notice:__ It is still possible that a banner show as same ad as a previous one when two banners' loading times are too close.

### Video ad
RUNA SDK provides video control method for video ads. 
It can be used at a scean like that we need to pause a video ad is shown in background view.

- **(void) toggleVideoAdPlay:(BOOL) shouldPlay**<br>
  - `shouldPlay`: Bool, Value `true` to play and `false` to pause.

### Get SDK Version String
The RUNA SDK is composed of multiple modules, such as Core, Banner, and others. Each module follows its own versioning system, and the overall RUNA SDK version is determined by the versions of these individual modules.

- __+(NSString*) RUNASDKVersionString__<br>

### Extensions

See [Extension Module](./extension/README.md)

### Distinct banners in group

Request distinct ad in a single request.
See [Banner Group](./group/README.md)

UI Component with group request.
See [Carousel View](./carousel/README.md)


## 2. Samples

### Normal case
![Language](http://img.shields.io/badge/language-ObjctiveC-red.svg?style=flat)

```objc
#import <RUNABanner/RUNABanner.h>
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
            if (banner.clickURL != nil) {
                banner.shouldPreventDefaultClickAction = YES;
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

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift
// SwiftUI case
import SwiftUI
import UIKit
import RUNABanner

struct CustomBannerView: UIViewRepresentable {
    let adspotId: String
    let adspotSize: RUNABannerViewSize

    func makeUIView(context: Context) -> UIView {
        let banner = RUNABannerView()
        banner.adSpotId = adspotId
        banner.size = adspotSize
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
                if let _ = view.clickURL {
                    view.shouldPreventDefaultClickAction = true
                    print("do something with the click url by self")
                }
            default:
                break
            }
        }

        return banner
    }
}
```

### Use RUNAAdSession to avoid duplicate ad

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift
// create an instance in the managed life cycle
private let adSession = RUNAAdSession()

...

// load first banner
banner1.session = adSession
banner1.load()

...

// be aware of loading second banner in a few time interval
banner2.session = adSession
banner2.load()
```

### Use AdSpotCode
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

### Test (Sample AdSpotId)

Sample display is possible with the following AdSpot ID.<br>
Please make sure if it is implemented correctly.

| Sample AdSpot ID |   Size    |                               Image                               |
| :--------------: | :-------: | :---------------------------------------------------------------: |
|      18252       | 300 x 250 | <img src="/doc/img/dummy_ads/dummy01_300x250.png" width=300px />  |
|      18253       | 320 x 50  |  <img src="/doc/img/dummy_ads/dummy02_320x50.png" width=300px />  |
|      18254       | 320 x 100 | <img src="/doc/img/dummy_ads/dummy03_320x100.png" width=300px />  |
|      18255       | 160 x 600 | <img src="/doc/img/dummy_ads/dummy04_160x600.png" height=400px /> |
|      18256       | 728 x 90  | <img src="/doc/img/dummy_ads/dummy05_728x90.png" width=300px />  |
|      18257       | 336 x 280 | <img src="/doc/img/dummy_ads/dummy06_336x280.png" width=300px />  |
|      18258       | 970 x 90  | <img src="/doc/img/dummy_ads/dummy07_970x90.png" width=300px />  |
|      18259       | 970 x 250 | <img src="/doc/img/dummy_ads/dummy08_970x250.png" width=300px /> |
|      18260       | 300 x 600 | <img src="/doc/img/dummy_ads/dummy09_300x600.png" width=300px />  |


### SwiftUI extension

See [Sample Code](../resources/ContentView.swift)

---

[TOP](/README.md#top)

---

LANGUAGE :

> [![ja](/doc/lang/ja.png)](/doc/ja/bannerads/README.md)
