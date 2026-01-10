<div id="top"></div>

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://developer.apple.com/ios/)
[![language](https://camo.githubusercontent.com/7387afbc27991b9739185470fcadf5475940be5a53886ec64f4df194a52911aa/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c616e67756167652d6f626a6563746976652d2d632d3642414545342e737667)](https://developer.apple.com/documentation)
![iOS](http://img.shields.io/badge/support-iOS_10+-blue.svg?style=flat)
![Xcode](http://img.shields.io/badge/IDE-Xcode_10+-blue.svg?style=flat)

# Rakuten Publisher Service iOS SDK
* [Ad Formats](#ad-formats)
* [Get Started](#get-started)
* [Prerequisites](#prerequisites)
* [Integrate SDK](#integrate-sdk)
* [CocoaPods](#cocoapods)
* [Swift Package Manager](#swift-package-manager)
* [M1 support](#m1-support)

### [Ad Formats](#ad-formats)

- **[Banner Ad](./doc/bannerads/README.md)**
- **[CarouselAds](./doc/bannerads/carousel/README.md)**
- **[Interstitial Ad](./doc/interstitial/README.md)**

---
# [Get Started](#get-started)

<div id="prerequisites"></div>

## [Prerequisites](#prerequisites)

* Xcode 10 or higher
* iOS 10 or higher
* Build iOS 17


<div id="import_sdk"></div>

## [Integrate SDK](#integrate-sdk)

### [CocoaPods](#cocoapods)

Put under lines into `Podfile`.

```ruby
source "https://github.com/rakuten-ads/Rakuten-Ads-iOS"

pod 'RUNA/Banner'
pod 'RUNA/OMAdapter'
```

### [Swift Package Manager](#swift-package-manager)

Swift Package Manager distribution support from 1.10.2 (1.10.1 deprecated).

Please use package's URL `https://github.com/rakuten-ads/Rakuten-Ads-iOS` in Xcode,

and select libraries from `RUNABanner`, `RUNAOMAdapter`.

`RUNAOMAdapter` is essential for the Open Measurement request. 


### [M1 support](#m1-support)

RUNA SDK starts to support xcframework from 1.10.1.

The implemenation for any past version in M1 Macbook, it is need to set `EXCLUDED_ARCHS[sdk=iphonesimulator*] = "arm64 armv7"` in Build Settings, or add a `post_install` hook for in `Podfile` like below.

```ruby
target 'App' do
  post_install do |installer|
    installer.pods_project.build_configurations.each do |configuration|
      configuration.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64 armv7"
    end
  end
end
```

---

[Banner Ad](./doc/bannerads/README.md)<br>
[CarouselAds](./doc/bannerads/carousel/README.md)<br>
[Interstitial Ad](./doc/interstitial/README.md)<br>
[Viewability Measurement](./doc/measurement/README.md)<br>
[MediationAdapter](./doc/mediation/README.md)<br>
[Manual implementation in standard WKWebView](./doc/wkwebview/README.md)<br>

---
LANGUAGE :
> [![jp](./doc/lang/ja.png)](./doc/ja)
