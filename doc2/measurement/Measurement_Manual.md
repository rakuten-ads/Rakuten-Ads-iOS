# Measurement Usage Manual

This manual introduces the usage of viewability and OM measurement features as implemented in `Measurement.swift`. It covers all demonstrated cases, configuration options, and best practices for integrating measurement in your iOS application.

---

## 1. Overview

The measurement API allows you to track ad viewability and OM (Open Measurement) compliance for both native views and web views. You can register measurement targets to the `ViewMeasurementProvider` for automatic tracking.

---

## 2. Native View Measurement

Register a native UIView for measurement:

```swift
let targetView = UIView()
let measurementTarget = UIViewTarget(targetView: targetView, viewImpURL: "https://example.com") { target in
    print("Measurement succeeded")
}
try! ViewMeasurementProvider.shared.register(target: measurementTarget)
```

- `UIViewTarget` is used for standard viewability measurement.
- `viewImpURL` is the impression tracking URL.
- The completion handler is called when measurement succeeds.

---

## 3. OM Measurement on UIView

Register a UIView for OM-compliant measurement:

```swift
let targetView = UIView()
let measurementTarget = OMNativeViewMeasurableTarget(targetView: targetView, vendorParameters: "my params")
try! ViewMeasurementProvider.shared.register(target: measurementTarget)
```

- `OMNativeViewMeasurableTarget` enables OM-compliant measurement for native views.
- `vendorParameters` can be used to pass custom OM parameters.

---

## 4. Dual Measurement on UIView

Register both standard and OM measurement for the same UIView:

```swift
let targetView = UIView()
let measurementTarget = UIViewTarget(targetView: targetView, viewImpURL: "https://example.com") { target in
    print("Measurement succeeded")
}
try! ViewMeasurementProvider.shared.register(target: measurementTarget)

let omMeasurementTarget = OMNativeViewMeasurableTarget(targetView: targetView)
try! ViewMeasurementProvider.shared.register(target: omMeasurementTarget)
```

- Both measurement targets can be registered for the same view to enable dual tracking.

---

## 5. OM Measurement on WebView

Register a WKWebView for OM-compliant measurement:

```swift
let webView = WKWebView()
webView.load(URLRequest(url: URL(string: "https://example.com")!)) // web with OM JS SDK script
let measurementTarget = OMWebViewMeasurableTarget(targetView: webView)
try! ViewMeasurementProvider.shared.register(target: measurementTarget)
```

- `OMWebViewMeasurableTarget` enables OM-compliant measurement for web views.
- The loaded web page should include the OM JS SDK script for proper tracking.

---

## 6. Best Practices

- Always register measurement targets after the view is added to the view hierarchy.
- Use OM measurement for industry-standard compliance and third-party verification.
- Use dual measurement if both standard and OM tracking are required.
- Handle completion callbacks for custom logic on measurement success.

---

## 7. Troubleshooting

- Ensure the target view or web view is visible and attached to the window before registering.
- Check for exceptions when registering targets; handle errors gracefully in production code.
- For OM measurement, verify that the OM JS SDK script is present in the web page.

---

## 8. References

- [RUNA SDK API Documentation](https://rakuten-ads.github.io/runasdk.github.io/iOS/)

For further assistance, rise a Github issue or contact support.
