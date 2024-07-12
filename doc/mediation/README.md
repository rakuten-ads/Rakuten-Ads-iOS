[TOP](/README.md#top)　>　 Mediation Adapter

---

# MediationAdapter

The module `MediationAdapter` is a SDK to serve ad with other SDK product through the mediation feature.
Currently we support the ad banner feature of `GoogleAdsMobile` SDK.

---

## How to Use

### Prepare `GoogleAdsMobile` SDK

#### Admob ad Unit

Get the ad Unit ID ready from the market side and follow the [introduction](https://developers.google.com/admob/ios/banner) to implement the `GADBanner` in the App.

#### Enable mediation configurations in Admob console.

Ask market side to enable the configuration of the Admob Mediation. The following 2 steps must be done.

1. set up a mediation group

1. add ad custom event and map it with class name `GADMediationAdapterRunaCustomEvent` as the ad source.


### Implement `RUNAMediationAdapter`

#### [Integrate SDK](#integrate-sdk)

- [CocoaPods](#cocoapods)
Edit the Podfile to contains the following configuration if using Cocoapods.

```ruby
source "https://github.com/rakuten-ads/Rakuten-Ads-iOS"

pod 'RUNA/MediationAdapter'
```

- [Swift Package Manager](#spm)

Add repository URL of `https://github.com/rakuten-ads/Rakuten-Ads-iOS` in Xcode,
and add package `RUNAMediationAdapter` to the target project.

`MediationAdapter` has been supported from RUNA SDK version `1.16.0`.

The `RUNAMediationAdapter` SDK dependents on `GoogleAdsMobile` SDK, but since the [SPM is not recommended by `GoogleAdsMobile` currently](https://developers.google.com/admob/ios/quick-start#spm),
`RUNAMediationAdapter` doesn't strict the dependency relation in the declare file while let developers to decide the method to import `GoogleAdsMobile` SDK.

#### Configure RUNA essential parameters

Configure the essential parameters in the class `RUNAAdParameter` for `RUNABanner` and register it to GAD by `GADAdNetworkExtras` protocol.


```swift
// set parameters for RUNA
var parameters = RUNAAdParameter()
parameters.adSpotId = "00000"
let extras = GADMediationAdapterRunaExtras()
extras.adParameter = parameters

// register the GADAdNetworkExtras before loading ad
req.register(extras)
```

__current supported parameters__

- adSpotId
- adSpotCode
- adSpotBranchId
- rz
- rp
- easyId
- rpoint
- customTargeting
- genre

Details of the values can be found in [Banner Ad](../bannerads/README.md)



### 
## Samples

### Normal case
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift

// create GADRequest
let req = GADRequest()

// set parameters for RUNA
var parameters = RUNAAdParameter()
parameters.adSpotId = "00000"
let extras = GADMediationAdapterRunaExtras()
extras.adParameter = parameters

// register the GADAdNetworkExtras
req.register(extras)

// GADBannerView load
bannerView.load(req)
```

### Case of complex banner configuration
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift

// create GADRequest
let req = GADRequest()

// set parameters for RUNA
var parameters = RUNAAdParameter()
parameters.adSpotId = "00000"
parameters.rz = "rzcookie"
let extras = GADMediationAdapterRunaExtras()
extras.adParameter = parameters

// register the GADAdNetworkExtras
req.register(extras)

// GADBannerView load
bannerView.load(req)
```


---

[TOP](/README.md#top)

---

LANGUAGE :

> [![ja](/doc/lang/ja.png)](/doc/ja/mediation/README.md)
