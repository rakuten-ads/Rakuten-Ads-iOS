<div id="top"></div>

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://developer.apple.com/ios/)
[![language](https://camo.githubusercontent.com/c26adc3630b1c213a4b3372979a3b805f7342746/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c616e67756167652d4f626a6563746976652d2d432d626c75652e737667)](https://developer.apple.com/documentation)
![iOS](http://img.shields.io/badge/support-iOS_10+-blue.svg?style=flat)
![Xcode](http://img.shields.io/badge/IDE-Xcode_10+-blue.svg?style=flat)

# Rakuten Publisher Service iOS SDK
* [広告フォーマット](#ad-formats)
* [はじめに](#get-started)
* [前提](#prerequisites)
* [SDK の導入](#integrate-sdk)
* [CocoaPods](#cocoapods)
* [Swift パッケージマネージャー](#swift-package-manager)
* [M1 サポート](#m1-support)

### [広告フォーマット](#ad-formats)

- **[バナー広告](./bannerads/README.md)**
- **[カルーセル広告](./bannerads/carousel/README.md)**
- **[インタースティシャル広告](./interstitial/README.md)**

---

# [はじめに](#get-started)

<div id="prerequisites"></div>

## [前提](#prerequisites)

- Xcode 10 以上
- iOS 10 以上
- iOS 17でビルド

<div id="import_sdk"></div>

## [SDK の導入](#integrate-sdk)

### [CocoaPods](#cocoapods)

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

### [Swift パッケージマネージャー](#swift-package-manager)

Swift パッケージマネージャー を1.10.2 のバージョンよりサポートしております。

こちらのURL `https://github.com/rakuten-ads/Rakuten-Ads-iOS` を XCodeに記載していただき、 `RUNABanner`, `RUNAOMAdapter`　を選択します。

`RUNAOMAdapter` は、 Open Measurement SDK (OMSDK)を使用される場合に必要となるモジュールです。

### [M1 サポート](#m1-support)

RUNA SDK ではバージョン1.10.1からサポートしています。

これより前のバージョンでM1 Macbookでサポートするためには, `EXCLUDED_ARCHS[sdk=iphonesimulator*] = "arm64 armv7"` を　Build Settings　に設定するか, `post_install` を `Podfile` に下記のように変更します。

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
[カルーセル広告](./bannerads/carousel/README.md)<br>
[インタースティシャル広告](./interstitial/README.md)<br>
[ビューアビリティ計測](./measurement/README.md)

---

LANGUAGE :

> [![en](../lang/en.png)](/README.md#top)
