[TOP](/README.md#top)　>　 ビューアビリティ計測

---

# ビューアビリティ計測

本機能は対象となる任意のViewの視認性の計測を実行し、視認性の確立後にコールバックすることが可能です。

---

## マニュアル

### ターゲットを指定
ターゲットとなるUIViewを指定する`RUNAMeasurableTarget`のインスタンスを作成し、
計測の設定を指定し望む計測方法を有効にします。

`RUNAMeasurableTarget`は RUNA と OM(open measurement) 二つの計測方法を提供しています。

#### RUNAMeasurementConfiguration
- `viewImpURL`: 視認状態に判定される際にURLがリクエストされます。
- `completionHandler`: 視認状態に判定される際にカスタムの処理が実行されます。

#### RUNAOMNativeProviderConfiguration
- `verificationJsURL`: vendor別の認証JS URL
- `providerURL`: OMSDK JS URL
- `vendorKey`: vendor別のキー
- `vendorParameters`: vendor別のパラメーター

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```Swift
let target = RUNAMeasurableTarget(view: aTargetView)
let runaConfig = RUNAMeasurementConfiguration()
runaConfig.viewImpURL = "<aImpURL>"
runaConfig.completionHandler = { (view) in
    print("viewability decteded")
}
let omConfig = RUNAOMNativeProviderConfiguration()
omConfig.verificationJsURL = "https://verification.js"
omConfig.providerURL = "https://provider.SDK.js"
omConfig.vendorKey = "<key>"
omConfig.vendorParameters = "<parameters>"

```

### 計測開始
ターゲットが`RUNAViewabilityProvider`に登録されたと、SDKはターゲットViewのメモリ参照を保持し、視認性監視を始ります。
ターゲットViewの半分以上が画面に入ると視認状態に判定されます。

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```Swift
RUNAViewabilityProvider.sharedInstance().register(target)
```

### 計測終了
ターゲットが消える後、メモリ参照を解除するため登録を外します。

## 3. Sample

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```Swift
import RUNABanner

var targetView: UIView!

// 計測開始
override func viewDidLoad() {
    // ...
    // 画面がロードする時に計測を始める
    let target = RUNAMeasurableTarget(view: targetView)
    let runaConfig = RUNAMeasurementConfiguration()
    runaConfig.viewImpURL = "<aImpURL>"
    runaConfig.completionHandler = { (view) in
        print("viewability decteded")
    }
    let omConfig = RUNAOMNativeProviderConfiguration()
    omConfig.verificationJsURL = "https://verification.js"
    omConfig.providerURL = "https://provider.SDK.js"
    omConfig.vendorKey = "<key>"
    omConfig.vendorParameters = "<parameters>"

    RUNAViewabilityProvider.sharedInstance().register(target)
}

// 計測終了
override func viewDidDisappear(_ animated: Bool) {
    // ...
    // 画面が消える際にメモリ参照を解除する
    RUNAViewabilityProvider.sharedInstance().unregisterTargetView(targetView)
}
```

---

[TOP](/README.md#top)

---

LANGUAGE :

> [![en](/doc/lang/en.png)](/doc/measurement/README.md)
