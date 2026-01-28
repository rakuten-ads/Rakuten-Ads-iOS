<div id="top"></div>

![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)
![language](http://img.shields.io/badge/language-ObjC-blue.svg?style=flat)
![language](http://img.shields.io/badge/language-Swift-blue.svg?style=flat)
![iOS](http://img.shields.io/badge/support-iOS_15+-blue.svg?style=flat)
![Xcode](http://img.shields.io/badge/IDE-Xcode_16+-blue.svg?style=flat)

# Rakuten Publisher Service iOS SDK
* [Get Started](#get-started)
* [Prerequisites](#prerequisites)
* [Integrate SDK](#integrate-sdk)
* [CocoaPods](#cocoapods)
* [Swift Package Manager](#swift-package-manager)
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

--
## [Implementation](#implementation)
- [For 1.x](./doc/README.md)
- [For 2.x](./doc2/README.md)

---

For further assistance, rise a Github issue or contact support.