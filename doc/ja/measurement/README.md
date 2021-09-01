[TOP](/README.md#top)　>　 Viewability Measurement Provider

---

# ビューアビリティ計測

RUNAViewabilityProvider　は目標とする任意のViewにビューアビリティ計測をサポートします。

---

## 1. 計測開始

### 1.1 register target view
ターゲットViewが登録されたと、SDKはターゲットViewの参照を保持してビューアビリティ状態を監視し始ります。
ターゲットViewの半分以上が画面に入るとViewable状態に判定されます。

### 1.2 view imp URL
Viewable状態に判定される際にURLがリクエストされます。

### 1.3 completion handler
Viewable状態に判定される際にカスタムの処理が実行されます。


## 2. 計測終了
計測終了後、メモリ参照を解除するため登録を外します。

## 3. 実装例

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```Swift
import RUNABanner

var targetView: UIView!

override func viewDidLoad() {
    // ...
    // 画面がロードする時に計測を始める
    let provider = RUNAViewabilityProvider.sharedInstance()
    provider.registerTargetView(targetView, withViewImpURL: aURL) { (view) in
        print("viewability decteded")
    }
}

override func viewDidDisappear(_ animated: Bool) {
    // ...
    // 画面が消える際にメモリ参照を解除する
    measurer.unregsiterTargetView(targetView)
}
```

---

[TOP](/README.md#top)

---

LANGUAGE :

> [![ja](/doc/lang/ja.png)](/doc/ja/measurement/README.md)
