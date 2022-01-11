# Carousel View
A scrollable ad view contains a set of banners.


## Properties

### Basic properties

- __NSArray<NSString*>* adSpotIds__

Simply indicate an array of `adSpotIds`, get from administrator site.

- __RUNABannerCarouselViewItemScale itemScaleMode__

Scale modes to determine the item banner's presenting contains ad content, default as `RUNABannerCarouselViewItemScaleAspectFit`.
> Enumeration:
>  - RUNABannerCarouselViewItemScaleAspectFit, fit the parent width and calculate height with aspect ratio
>  - RUNABannerCarouselViewItemScaleFixedWidth, indicate a fixed width and calculate height with aspect ratio

### Advanced properties for carousel view

- __NSArray<RUNABannerView*>* itemViews__

This properties will ignores the `adSpotIds` property, instead set an array of ad item banner view as a `RUNABannerView` with individual configurations as same as the [RUNABannerView configurations](../bannerads/README.md#Configurations).<BR/>
And the `Size` and `Position` properties of each item banner view will be ignored as the carousel view will overtake the presenting style of the item banner views.


- __CGFloat itemSpacing__

Spacing between item banner views.

- __UIEdgeInsets contentEdgeInsets__

Edge insets of the carousel view content.

- __CGFloat minItemOverhangWidth__

Minimum width to overhang the next item banner view.

### 1.3 Advanced properties for individual item banner view

- __UIEdgeInsets itemEdgeInsets__

Edge insets of each item banner view.

- __RUNABannerCarouselViewItemDecorator decorator__

A callback block to customize the item view.

- __CGFloat itemWidth__

A fixed with of item banner view, only enable when itemScaleMode is `RUNABannerCarouselViewItemScaleFixedWidth`.

- __NSInteger itemCount__

The count of items successfully loaded.



## Functions

- __load()__

Start to load ad content.

- __loadWithEventHandler:(nullable void (^)(RUNABannerCarouselView* view, struct RUNABannerViewEvent event)) handler__

Start to load ad content with an event handler. An event contains event type and error code.


#### RUNABannerViewEventType

- RUNABannerViewEventTypeGroupFinished

All item banner views of the carousel view load finished, no matter succeed or failed.

- RUNABannerViewEventTypeGroupFailed

Failed during carousel view load


## Extension

See [Extension Module](./extension/README.md)


## Use cases

- Quick start

```Swift
let carouselView = RUNABannerCarouselView()
carouselView.adSpotIds = ["id1", "id2", "id3"]
carouselView.load()
```

- Advanced configuractions of carousel view and each of item banner view and events monitoring

```Swift
let carouselView = RUNABannerCarouselView()
carouselView.contentEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
carouselView.setRz("aRzCookie")
carouselView.itemViews = ["id1", "id2", "id3"].map { adspotId in
    let banner = RUNABannerView()
    banner.adspotId = adspotId
    banner.setCustomTargeting(customTargeting)
    return banner
}
carouselView.load { [weak self] (group, banner, event) in
    guard let self = self else {
        return
    }
    
    switch event.eventType {
    case .succeeded:
        Logger.debug("carousel item banner succeeded")
    case .failed:
        Logger.debug("carousel item banner failed")
    case .groupFinished:
        Logger.debug("carousel all item load finished")
    case .groupFailed:
        Logger.debug("carousel load failed")
    default:
        break
    }
}
```

- Customize item banner view style in high level

```Swift
let carouselView = RUNABannerCarouselView()
carouselView.itemViews = ["id1", "id2", "id3"].map { adspotId in
    let banner = RUNABannerView()
    banner.adspotId = adspotId
    banner.setCustomTargeting(customTargeting)
    return banner
}
carouselView.decorator = { [weak self] item, position in
    let marginView = UIView()
    marginView.translatesAutoresizingMaskIntoConstraints = false
    marginView.addSubview(item)
    marginView.addConstraints([
        item.leadingAnchor.constraint(equalTo: marginView.leadingAnchor),
        item.trailingAnchor.constraint(equalTo: marginView.trailingAnchor),
        item.topAnchor.constraint(equalTo: marginView.topAnchor),
        item.bottomAnchor.constraint(equalTo: marginView.bottomAnchor),
    ])

    let container = UIView()
    container.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    container.translatesAutoresizingMaskIntoConstraints = false
    container.backgroundColor = bgColor
    container.addSubview(marginView)
    container.addConstraints([
        marginView.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
        marginView.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor),
        marginView.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
        marginView.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor),
    ])
    return container
}
carouselView.load { [weak self] (group, banner, event) in
    guard let self = self else {
        return
    }
    
    switch event.eventType {
    case .succeeded:
        Logger.debug("carousel item banner succeeded")
    case .failed:
        Logger.debug("carousel item banner failed")
    case .groupFinished:
        Logger.debug("carousel all item finished")
    case .groupFailed:
        Logger.debug("carousel load failed")
    default:
        break
    }
}
```

---

[TOP](/README.md#top)

---

LANGUAGE :

> [![ja](/doc/lang/ja.png)](/doc/ja/bannerads/README.md)