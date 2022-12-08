[TOP](/README.md#top)　>　 [Banner Ads](../README.md)

---

# Extension Module for Banner Ads

The extension module gives several special configurations for certain purposes. <br>
Before using these configurations, appropriate values need to be confirmed first from the market admin sides.

---

## How To Use

### import

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
import RUNABanner.Extension
```

![Language](http://img.shields.io/badge/language-ObjctiveC-red.svg?style=flat)
```Objc
#import <RUNABanner/RUNABannerViewExtension.h>
```

### Configurations

#### Genre

- masterId: `Int`
- code : `String`, non-null
- match: `String`, non-null

```Swift
let genre = RUNABannerViewGenreProperty(masterId: 1, code: genreId, match: "man")
bannerView.setPropertyGenre(genre)
```

#### Custom Targeting

- targeting: `[String: [String]]]`, non-null <br>
A dictionary has entries with __String__ keys and __String array__ values.

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
RUNABannerUtil provides api to normalize any string values for convenience, contains following rules:

- convert half-width to full-width (カナ, 濁点, 半濁点, 長音符)
- convert full-width to half-width (digit, alphabet, space, double quotation)
- convert upper-case to lower-case (alphabet)
- convert multi (>=2) spaces to single space trim spaces
- remove spaces at start and end of phrase

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

#### Geo

- latitude: `double`, from -90.0 to +90.0, where negative is south
- longitude: `double`, from -180.0 to +180.0, where negative is west

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
let lat = location.coordinate.latitude
let lon = location.coordinate.longitude
bannerView.setLocation(latitude: lat, longitude: lon)
```