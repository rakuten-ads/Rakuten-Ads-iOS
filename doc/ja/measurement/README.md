[TOP](/README.md#top)　>　 ビューアビリティ計測

---

# ビューアビリティ計測

本機能は対象となる任意のViewの視認性の計測を実行し、視認性の確立後にコールバックすることが可能です。

---

## 1. 計測開始

### 1.1 register target view
ターゲットViewが登録されたと、SDKはターゲットViewのメモリ参照を保持し、視認性監視を始ります。
ターゲットViewの半分以上が画面に入ると視認状態に判定されます。

### 1.2 view imp URL
視認状態に判定される際にURLがリクエストされます。

### 1.3 completion handler
視認状態に判定される際にカスタムの処理が実行されます。


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

> [![en](/doc/lang/en.png)](/doc/measurement/README.md)
