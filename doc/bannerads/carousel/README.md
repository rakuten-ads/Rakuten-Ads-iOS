[TOP](/README.md#top)　>　 [Banner Ads](../README.md)

---

# Carousel View

A `RUNACarouselView` is a convenient UI component shows a group of banner ads with distinct contents by using `RUNABannerGroup`, bases on an `UICollectionView` in horizontal orientation.

## How to use

### Basic properties

- adSpotIds<br>
An array of `adSpotId` required when `adSpotCode` is nil, get from administrator site.

- adSpotCodes<br>
An array of `adSpotCode` required when `adSpotId` is nil, get from administrator site. 

- itemViews<br>
An array of `RUNABannerView` can be used when complex settings of banner is needed , e.g. custom targeting. This will ignore `adSpotIds` & `adSpotCodes` properties.

- itemScaleMode<br>
  - RUNABannerCarouselViewItemScaleAspectFit: Fit the parent width and calculate height with aspect ratio.
  - RUNABannerCarouselViewItemScaleFixedWidth: Indicate a fixed width and calculate height with aspect ratio.

### Advance settings

- itemSpacing<br>
Spacing between item banner views.

- contentEdgeInsets<br>
Edge insets of the carousel view content

- minItemOverhangWidth<br>
Minimum width to overhang the next item banner view.

### Advance setting for item banner view

- itemEdgeInsets<br>
Edge insets of each item banner view.

- itemWidth<br>
Fixed with of item view, only enable when `itemScaleMode` is `RUNABannerCarouselViewItemScaleFixedWidth`.

- itemCount<br>
The count of items successfully loaded, readonly.

- decorator<br>
A callback block to customize each item banner view.

## Samples

### Simple implement
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift

let carouselView = RUNABannerCarouselView()
carouselView.adSpotIds = ["id1","id2","id3"]
carouselView.load { [weak self] carouselView, banner, event in
    if case .groupFinished = event.eventType {
        self.view.addSubview(carouselView)
    }
}
```

### complex settings of RUNABannerView
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift

let carouselView = RUNABannerCarouselView()
carouselView.adSpotIds = ["id1","id2","id3"].map{ adspotId in
    let itemView = RUNABannerView()
    itemView.adSpotId = adspotId
    itemView.setCustomTargeting(targetings)

    // need import RUNABanner.Extension 
    itemView.setPropertyGenre(RUNABannerViewGenreProperty(masterId: masterid, code: code, match: match))
    
    return itemView
}
carouselView.load { [weak self] carouselView, banner, event in
    if case .groupFinished = event.eventType {
        self.view.addSubview(carouselView)
    }
}
```

### item view decoration
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
let carouselView = RUNABannerCarouselView()
carouselView.adSpotIds = ["id1","id2","id3"]
carouselView.decorator = { banner, position in
    // banner view will always fit the parent view's width anchor, thus there is a need to wrap with an UIView
    let marginView = UIView()
    marginView.translatesAutoresizingMaskIntoConstraints = false
    marginView.addSubview(banner)
    marginView.addConstraints([
        banner.leadingAnchor.constraint(equalTo: marginView.leadingAnchor),
        marginView.trailingAnchor.constraint(equalTo: banner.trailingAnchor),
        banner.topAnchor.constraint(equalTo: marginView.topAnchor),
        marginView.bottomAnchor.constraint(equalTo: banner.bottomAnchor),
    ])

    // apply layoutMargins for the margin view
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    container.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    container.addSubview(marginView)
    container.addConstraints([
        marginView.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
        marginView.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
        container.layoutMarginsGuide.trailingAnchor.constraint(equalTo: marginView.trailingAnchor),
        container.layoutMarginsGuide.bottomAnchor.constraint(equalTo: marginView.bottomAnchor),
    ])
    container.backgroundColor = .white
    return container
}
carouselView.load { [weak self] carouselView, banner, event in
    if case .groupFinished = event.eventType {
        self.view.addSubview(carouselView)
    }
}
```