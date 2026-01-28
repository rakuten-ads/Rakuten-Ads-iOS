<div id="top"></div>

![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)
![language](http://img.shields.io/badge/language-ObjC-brightgreen.svg?style=flat)
![language](http://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat)
![iOS](http://img.shields.io/badge/support-iOS_15+-orange.svg?style=flat)
![Xcode](http://img.shields.io/badge/IDE-Xcode_16+-orange.svg?style=flat)

# Rakuten Publisher Service iOS SDK
* [Get Started](#get-started)
* [Prerequisites](#prerequisites)
* [Integrate SDK](#integrate-sdk)
* [Swift Package Manager](#swift-package-manager)
* [CocoaPods](#cocoapods)
* [M1 support](#m1-support)
* [Implementation](#implementation)

---
# [Get Started](#get-started)

<div id="prerequisites"></div>

## [Prerequisites](#prerequisites)

* Xcode 16 or higher
* iOS 15 or higher
* Build iOS 18


<div id="import_sdk"></div>

## [Integrate SDK](#integrate-sdk)

### [Swift Package Manager](#swift-package-manager)

Swift Package Manager distribution support from 1.10.2 (1.10.1 deprecated).

Please use package's URL `https://github.com/rakuten-ads/Rakuten-Ads-iOS` in Xcode,

and select libraries from `RUNABanner`, `RUNAOMAdapter`, `RUNAMediation`.

- `RUNABanner` is essential for variety ad formats supported by RUNA.
- `RUNAOMAdapter` is essential for the Open Measurement coorperation. 
- `RUNAMediationAdapter` is for demanding of mediation support. Now it has support for Admob


### [CocoaPods](#cocoapods)

Put under lines into `Podfile`.

```ruby
source "https://github.com/rakuten-ads/Rakuten-Ads-iOS"

pod 'RUNA/Banner'
pod 'RUNA/OMAdapter'
```

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

## [Manual](#manual)
- [For version 1.x](./doc/README.md)
- [For version 2.x](./doc2/README.md)

---

For further assistance, rise a Github issue or contact support.