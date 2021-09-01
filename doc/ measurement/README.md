[TOP](/README.md#top)　>　 Viewability Measurement Provider

---

# Viewability Measurement

RUNAViewabilityProvider helps to detect the viewability of an arbitrary target UIView.

---

## 1. Start measurement

### 1.1 register target view
A UIView registered will be retained by SDK which start detecting the target's viewable state.
When the target view show within the screen at a size larger than 50% of its complete size, 
it will be judged as is viewable.

### 1.2 view imp URL
An optional URL can be called when viewability detected.

### 1.3 completion handler
Customized handler can be invoke when viewability detected.


## 2. Stop measurement
Unregister the target UIView to release reference retainment.

## 3. Sample

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```Swift
import RUNABanner

var targetView: UIView!

override func viewDidLoad() {
    // ...
    // start measurement when targetView loaded
    let provider = RUNAViewabilityProvider.sharedInstance()
    provider.registerTargetView(targetView, withViewImpURL: aURL) { (view) in
        print("viewability decteded")
    }
}

// stop measurement
override func viewDidDisappear(_ animated: Bool) {
    // ...
    measurer.unregsiterTargetView(targetView)
}
```

---

[TOP](/README.md#top)

---

LANGUAGE :

> [![ja](/doc/lang/ja.png)](/doc/ja/measurement/README.md)