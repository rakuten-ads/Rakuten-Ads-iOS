[TOP](/README.md#top)　>　 [Banner Ads](../README.md)

---

# グループで異なる広告リクエスト

RUNA SDKは一回複数異なる広告をリクエストするため`RUNABannerGroup`を提供しますので、一画面に複数異なる広告或いはカルーセルタイプ広告バナーを表示する場合簡単に使われます。

---

## How to use

- 複数`RUNABannerView`を作成し、adspotIdなどの設定をそれぞれ設定します。
- リストにして`RUNABannerGroup`にアサインする
- `RUNABannerGroup`が代理となり、それぞれ`RUNABannerView`の代わりに`load` メソッドを実行させます。

## 拡張設定

#### Rz Cooke

- rz: `String`, non-null

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)
```Swift
bannerGroup.setRz("RzCookie")
```

## サンプル
```Swift
// ロード完成したバナーの参照
var banners:[RUNABannerView] = []

// ...

// グループで広告内容取得
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

### 広告を特定する
`RUNABannerView`の`UIView`から継承した`tag`初期化時に指定し、その後コールバックで特定します。