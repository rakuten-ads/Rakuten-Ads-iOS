[TOP](/README.md#top)　>　 [バナー広告]](../README.md)

---

# バナー拡張モジュール

バナー拡張モジュールは特定な目的のためいくつの設定項目を用意しています。<br>
使う前に、適切な値設定をマーケット担当者から確認する必要があります。

---

## 使い方

### 導入

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
import RUNABanner.Extension
```

![Language](http://img.shields.io/badge/language-ObjctiveC-red.svg?style=flat)
```Objc
#import <RUNABanner/RUNABannerViewExtension.h>
```

### 設定項目

#### ジャンル

- masterId: `Int`
- code : `String`, non-null
- match: `String`, non-null

```Swift
let genre = RUNABannerViewGenreProperty(masterId: 1, code: genreId, match: "man")
bannerView.setPropertyGenre(genre)
```

#### カスタマターゲット

- targeting: `[String: [String]]]`, non-null <br>
__文字列__のキーと__文字列の配列__の値を持つディクショナリーのタイプです。

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
var runaCustomTargeting: [String: [String]] {
    return [
        Constant.appDeviceType: [deviceTyString],
        Constant.appVersion: [appVersion],
        Constant.sdkVersion: [sdkVersion],
        Constant.osVersion: [osVersion],
        Constant.os: [os]
    ]
}
bannerView.setCustomTargeting(runaCustomTargeting)
```

##### Normalization
便利のため、RUNABannerUtilは文字列をnormalize化するAPIを用意しています。下記のルールに基づきます：

- 半角を全角へ変換 (カナ, 濁点, 半濁点, 長音符)
- 全角を半角へ変換 (数字, アルファベット, スペース, ダブルコーテーション)
- 大文字を小文字へ変換 (アルファベット)
- ２個以上連続のスペースを一つへ変換
- 最初と最後のスペースを削除

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
var runaCustomTargeting: [String: [String]] {
    return [
        Constant.key1: ["value1", "value2"],
        Constant.key2: ["value3"],
    ]
}
let targetingWithNormalizedValues = runaCustomTargeting.mapValues{$0.map(RUNABannerUtil.normalize(_:))}
bannerView.setCustomTargeting(targetingWithNormalizedValues)
```

#### Rz Cooke

- rz: `String`, non-null

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
bannerView.setRz("RzCookie")
```

#### Rp Cooke

- rp: `String`, non-null

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
bannerView.setRp("RpCookie")
```

#### EasyId

- easyId: `String`, non-null

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
bannerView.setEasyId("123456789")
```

#### 地理情報

- latitude: `double`, 値は -90.0 から +90.0 まで, マイナス値は南を表す
- longitude: `double`, 値は -180.0 から +180.0 まで, マイナス値は西を表す

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
let lat = location.coordinate.latitude
let lon = location.coordinate.longitude
bannerView.setLocation(latitude: lat, longitude: lon)
```