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

#### 地理情報

- latitude: `double`, 値は -90.0 から +90.0 まで, マイナス値は南を表す
- longitude: `double`, 値は -180.0 から +180.0 まで, マイナス値は西を表す

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
let lat = location.coordinate.latitude
let lon = location.coordinate.longitude
bannerView.setLocation(latitude: lat, longitude: lon)
```