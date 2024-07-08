[TOP](/README.md#top)　>　 Mediation Adapter

---

# MediationAdapter

The module `MediationAdapter` is an SDK to connect with the mediation function of other SDK products.
Currently we only have the support for `GADBanner` feature of `GoogleAdsMobile` SDK.

---

## How to Use

### Prepare with `GoogleAdsMobile`

#### Prepare the Admob account

Follow the [introduction](https://developers.google.com/admob/ios/banner) and implement the Googel Ad banner.


#### Enable mediation configurations in Admob console.

0. set up a mediation group

0. adding ad custom event as ad source and mapping the custom event with class name `GADMediationAdapterRunaCustomEvent`. 


### Implement `RUNAMediationAdapter`

#### [Integrate SDK](#integrate-sdk)

- [CocoaPods](#cocoapods)
Edit the Podfile to contains the following configuration.

```ruby
source "https://github.com/rakuten-ads/Rakuten-Ads-iOS"

pod 'RUNA/MediationAdapter'
```

- [Swift Package Manager](#spm)

Add package from URL `https://github.com/rakuten-ads/Rakuten-Ads-iOS` in Xcode,
and add `RUNAMediationAdapter` to target project.

`MediationAdapter` is supported from RUNA SDK version `1.16.0`.

The `MediationAdapter` SDK is dependent on `GoogleAdsMobile` SDK, but since the [SPM is not recommanded by `GoogleAdsMobile` currently](https://developers.google.com/admob/ios/quick-start#spm),
`RUNAMediationAdapter` doesn't declare the dependency relation with it while let user to decide the method to import `GoogleAdsMobile` SDK.

#### Configure RUNA essential parameters

```swift
// set parameters for RUNA
var parameters = RUNAAdParameter()
parameters.adSpotId = "00000"
let extras = GADMediationAdapterRunaExtras()
extras.adParameter = parameters

// register the GADAdNetworkExtras before loading ad
req.register(extras)
```

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
