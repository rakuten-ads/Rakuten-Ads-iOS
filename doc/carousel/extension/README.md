[TOP](/README.md#top)　>　 [Banner Ads](../README.md)

---

# Extension Module for Carousel View Ad

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
#import <RUNABanner/RUNABannerCarouselViewExtension.h>
```

### Configurations

#### Rz Cookie

`Rz cookie` must be set to the CarouselView instead of each item banner view.

- rz: `String`, non-null

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
bannerView.setRz("RzCookie")
```