[TOP](/README.md#top)　>　 Viewability Measurement Provider

---

# Viewability Measurement

RUNAViewabilityProvider helps to detect the viewability of an arbitrary target UIView.

---

## Manual

### Configure measurement target
Create A `RUNAMeasurableTarget` instance to refer a UIView as the view-ability measuring target 
and enable desired measurement methods by setting required configurations.

The `RUNAMeasurableTarget` support both two method of measurements, RUNA and OM(open measurement)

#### RUNAMeasurementConfiguration
- `viewImpURL`: a URL to be sent when view ability measurered
- `completionHandler`: custom handler invoked when view ability measurered

#### RUNAOMNativeProviderConfiguration
- `verificationJsURL`: verification JS URL for vendor
- `providerURL`: OMSDK JS URL
- `vendorKey`: key for vendor
- `vendorParameters`: parameters for vendor

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

### Start measurement
Register the configured target instance to the `RUNAViewabilityProvider` instance and start detecting the target's viewability state.
The target will be considered as viewable state When it is show within the screen at a size larger than 50% of its complete size.

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```Swift
RUNAViewabilityProvider.sharedInstance().register(target)
```

### Stop measurement
Unregister the target UIView to release reference retainment When dismissing.

## 3. Sample

![Language](http://img.shields.io/badge/language-Swift-red.svg?style=flat)

```Swift
import RUNABanner

var targetView: UIView!

override func viewDidLoad() {
    // ...
    // start measurement when targetView loaded
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

// stop measurement
override func viewDidDisappear(_ animated: Bool) {
    // ...
    // unregister targetView when view disappear
    RUNAViewabilityProvider.sharedInstance().unregisterTargetView(targetView)
}
```

---

[TOP](/README.md#top)

---

LANGUAGE :

> [![ja](/doc/lang/ja.png)](/doc/ja/measurement/README.md)
