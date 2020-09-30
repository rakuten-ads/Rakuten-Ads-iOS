<div id="top"></div>

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://developer.apple.com/ios/)
[![language](https://camo.githubusercontent.com/c26adc3630b1c213a4b3372979a3b805f7342746/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c616e67756167652d4f626a6563746976652d2d432d626c75652e737667)](https://developer.apple.com/documentation)
![iOS](http://img.shields.io/badge/support-iOS_10+-blue.svg?style=flat)
![Xcode](http://img.shields.io/badge/IDE-Xcode_10+-blue.svg?style=flat)

# Rakuten Publisher Service iOS SDK

### 広告フォーマット

- **[バナー広告](./bannerads/README.md)**
- **[App to App](./doc/a2a/README.md)**
---

# はじめに

<div id="prerequisites"></div>

## 前提

- Xcode 10 以上
- iOS 10 以上

<div id="import_sdk"></div>

## SDK の導入

### CocoaPods

`Podfile`に下記の設定を追加.

```ruby
source "https://github.com/rakuten-ads/Rakuten-Ads-iOS"

pod 'RUNA/Banner'
pod 'RUNA/OMAdapter'
```

- __xcode 12 `EXCLUDED_ARCHS` 問題__

Build Settings に`EXCLUDED_ARCHS[sdk=iphonesimulator*] = "arm64 armv7"` 手動で設定する, 或いは下記のように `Podfile` に `post_install` hookを追加する.

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

[バナー広告](./bannerads/README.md)<br>
[App to App](./doc/a2a/README.md)

---

LANGUAGE :

> [![en](../lang/en.png)](/README.md#top)
