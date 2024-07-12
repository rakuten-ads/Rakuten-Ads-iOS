[TOP](/README.md#top)　>　 Mediation Adapter

---

# MediationAdapter

モジュール `MediationAdapter`はメディエーション機能を提供する他社の広告製品と連携するためのSDKです。
現在は`GoogleAdsMobile` SDKのbanner機能をサポートしています。

---

## How to Use

### `GoogleAdsMobile`を準備

#### Admob ad Unit

マーケット側から用意されたad Unit IDを取得し、[GADBannerの導入手順](https://developers.google.com/admob/ios/banner)に従いbanner機能をアプリに実装する。

#### Admob consoleでmediation設定を有効に.

マーケット側にメディエーションの設定を有効するようと依頼する。

1. mediation groupの設定

1. ad custom eventを追加し、ad sourceとしてclass名 `GADMediationAdapterRunaCustomEvent` をマップする.


### `RUNAMediationAdapter`を実装

#### [SDK導入](#integrate-sdk)

- [CocoaPods](#cocoapods)
CocoaPodsを利用する場合、Podfileを下記のように編集する

```ruby
source "https://github.com/rakuten-ads/Rakuten-Ads-iOS"

pod 'RUNA/MediationAdapter'
```

- [Swift Package Manager](#spm)

URL `https://github.com/rakuten-ads/Rakuten-Ads-iOS`からパッケージをXcodeに導入し、
目標のtarget projectに`RUNAMediationAdapter`モジュールを追加する。

RUNA SDK `1.16.0`から`RUNAMediationAdapter`SDKが提供された。
`GoogleAdsMobile` SDKを依頼しているが、[`GoogleAdsMobile`現在SPMではなくCocoapodsの導入を推薦しているため](https://developers.google.com/admob/ios/quick-start#spm)、
`RUNAMediationAdapter`はこの依頼関係を明示していない、開発者に`GoogleAdsMobile` SDKの導入方法の決定を委ねます。

#### 必要なRUNAのパラメーターを設定

`RUNAAdParameter`を使って必要なパラメーターを設定して`GADAdNetworkExtras`プロトコルに沿い、GADに登録する。


```swift
// set parameters for RUNA
var parameters = RUNAAdParameter()
parameters.adSpotId = "00000"
let extras = GADMediationAdapterRunaExtras()
extras.adParameter = parameters

// register the GADAdNetworkExtras before loading ad
req.register(extras)
```

__サポートするパラメーター__

- adSpotId
- adSpotCode
- adSpotBranchId
- rz
- rp
- easyId
- rpoint
- customTargeting
- genre

詳細はここへ参照してください：[Banner Ad](../bannerads/README.md)



### 
## Samples

### シンプルケース
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift

// create GADRequest
let req = GADRequest()

// set parameters for RUNA
var parameters = RUNAAdParameter()
parameters.adSpotId = "00000"
let extras = GADMediationAdapterRunaExtras()
extras.adParameter = parameters

// register the GADAdNetworkExtras
req.register(extras)

// GADBannerView load
bannerView.load(req)
```

### 複雑な設定を利用するケース
![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```swift

// create GADRequest
let req = GADRequest()

// set parameters for RUNA
var parameters = RUNAAdParameter()
parameters.adSpotId = "00000"
parameters.rz = "rzcookie"
let extras = GADMediationAdapterRunaExtras()
extras.adParameter = parameters

// register the GADAdNetworkExtras
req.register(extras)

// GADBannerView load
bannerView.load(req)
```

---

[TOP](/README.md#top)

---

LANGUAGE :

> [![ja](/doc/lang/ja.png)](/doc/ja/mediation/README.md)
