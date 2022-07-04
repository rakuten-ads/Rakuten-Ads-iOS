[TOP](/README.md#top)　>　 [Banner Ads](../README.md)

---

# Carousel View

`RUNACarouselView` は`RUNABannerGroup`を基づく、横スクロールの`UICollectionView`をベースにして、複数異なるバナー広告を表示させる便利なUI部品です。

## How to use

### 基本設定

- adSpotIds<br>
`adSpotId` の配列を指定する。`adSpotCodes`がnilの時必要です。管理サイドから獲得できます。

- adSpotCodes<br>
`adSpotCode` の配列を指定する、`adSpotIds`がnilの時必要です。管理サイドから獲得できます。

- itemViews<br>
`RUNABannerView` の配列を指定する。複雑な細かい設定が必要な時に利用する。例えば、カスタマイズターゲッティングなど。設定された場合、`adSpotIds` と `adSpotCodes` は無視されます。

- itemScaleMode<br>
  - RUNABannerCarouselViewItemScaleAspectFit: 親ビューの横幅を合わせって、比率を維持し縦幅を決める
  - RUNABannerCarouselViewItemScaleFixedWidth: 横幅を固定値に指定し、比率を維持し縦幅を決める

### 高度な設定

- itemSpacing<br>
バナーアイテムの間の距離

- contentEdgeInsets<br>
カルセル内部余白

- minItemOverhangWidth<br>
次に表示するバナーのはみ出す横幅

### 各バナーアイテムの高度な設定

- itemEdgeInsets<br>
各バナーアイテムの内部余白

- itemWidth<br>
`itemScaleMode`を`RUNABannerCarouselViewItemScaleFixedWidth`に設定する際に、バナーアイテムの横幅の固定値です。

- itemCount<br>
表示に成功したバナーアイテムの数です。読み取りだけ。

- decorator<br>
各バナーアイテムを高度なデコレーションできるコールバック

## サンプル

### 簡易なサンプル
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

### 複雑なRUNABannerViewを設定する
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift

let carouselView = RUNABannerCarouselView()
carouselView.adSpotIds = ["id1","id2","id3"].map{ adspotId in
    let itemView = RUNABannerView()
    itemView.adSpotId = adspotId
    itemView.setCustomTargeting(targetings)

    // import RUNABanner.Extension が必要
    itemView.setPropertyGenre(RUNABannerViewGenreProperty(masterId: masterid, code: code, match: match))
    
    return itemView
}
carouselView.load { [weak self] carouselView, banner, event in
    if case .groupFinished = event.eventType {
        self.view.addSubview(carouselView)
    }
}
```

###  バナーアイテムをデコレーション
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
let carouselView = RUNABannerCarouselView()
carouselView.adSpotIds = ["id1","id2","id3"]
carouselView.decorator = { banner, position in
    // banner viewが親ビューの横幅に合わせるのでここで一つUIViewを包むのが必要
    let marginView = UIView()
    marginView.translatesAutoresizingMaskIntoConstraints = false
    marginView.addSubview(banner)
    marginView.addConstraints([
        banner.leadingAnchor.constraint(equalTo: marginView.leadingAnchor),
        marginView.trailingAnchor.constraint(equalTo: banner.trailingAnchor),
        banner.topAnchor.constraint(equalTo: marginView.topAnchor),
        marginView.bottomAnchor.constraint(equalTo: banner.bottomAnchor),
    ])

    // margin viewにマージンを適用
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