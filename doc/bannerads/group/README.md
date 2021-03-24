[TOP](/README.md#top)　>　 [Banner Ads](../README.md)

---

# Distinct Banners in Group

RUNA SDK provides `RUNABannerGroup` to retrive a bunch of distinct banners once by a single request, which is supposed to simplify the usage of showing different ads in one page of view or a carousel view.

---

## How to use

- Initalize a list of `RUNABannerView` instances by setting `adspotId` and other perspectives individually.
- Assign the list to a `RUNABannerGroup` instance.
- Take `RUNABannerGroup` as a proxy for all `RUNABannerView` of the list, use the method `load` to request the multiple ad contents instead of the same method of each `RUNABannerView`.

## Extension Setting

#### Rz Cooke

- rz: `String`, non-null

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
bannerGroup.setRz("RzCookie")
```

## Sample
```Swift
// reference to keep succeed banners
var banners:[RUNABannerView] = []

// ...

// request ads by group
let bannerGroup = RUNABannerGroup()
bannerGroup.banners = makeBanners()
bannerGroup.load { (group, banner, event) in
    switch event.eventType {
    case .succeeded:
        if let b = banner {
            self.banners.append(b)
        }
    case .failed:
        print("received event failed \(event.error)")
    default:
        print("other event \(event.eventType)")
    }
}
```

## Tips

### Identify a BannerView in a group
Simply set the property `tag` of `RUNABannerView` inherited from super class `UIView` when initilization, and then use it to identify banner in the callback closure.