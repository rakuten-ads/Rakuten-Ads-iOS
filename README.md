<div id="top"></div>

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://developer.apple.com/ios/)
[![language](https://camo.githubusercontent.com/c26adc3630b1c213a4b3372979a3b805f7342746/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c616e67756167652d4f626a6563746976652d2d432d626c75652e737667)](https://developer.apple.com/documentation)
![iOS](http://img.shields.io/badge/support-iOS_10+-blue.svg?style=flat)
![Xcode](http://img.shields.io/badge/IDE-Xcode_10+-blue.svg?style=flat)

# Rakuten Publisher Service iOS SDK

### Ad Formats

* **[Banner Ad](./doc/bannerads/README.md)**

---
# Get Started

<div id="prerequisites"></div>

## Prerequisites

* Xcode 10 or higher
* iOS 10 or higher


<div id="import_sdk"></div>

## Integrate SDK

### CocoaPods
Put under lines into `Podfile`.

```ruby
source "https://github.com/rakuten-ads/Rakuten-Ads-iOS"

pod 'RUNA/Banner'
pod 'RUNA/OMAdapter'
```

- __xcode 12 `EXCLUDED_ARCHS` issue__

Need set `EXCLUDED_ARCHS[sdk=iphonesimulator*] = "arm64 armv7"` in Build Settings, or add a `post_install` hook for in `Podfile` like below.

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
[Viewability Measurement](./doc/measurement/README.md)

---
LANGUAGE :
> [![jp](./doc/lang/ja.png)](./doc/ja)
