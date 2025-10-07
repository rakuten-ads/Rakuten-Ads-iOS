[TOP](/README.md#top)　>　 Manual implementation in standard WKWebView

---

# Manual Implementation in WKWebView

This guide explains how to load a RUNA ad template in a standard WKWebView and handle ad click events.

## Prerequisite
### OS support

- Xcode 15 or later
- iOS 13 or later


### HTML Ad Template Preparation

- Import the JS SDK:  
  `https://s-cdn.rmp.rakuten.co.jp/js/aa.js`
- Define a container DIV for the banner.
- Configure `AD_SPOT_ID` as specified in the web admin console.
- If needed, include a viewport META tag in the HEAD.

#### Sample HTML
```HTML
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://s-cdn.rmp.rakuten.co.jp/js/aa.js" async></script>
    </head>
    <body>
        <h1>Test</h1>
        <div id="runa_sdk"></div>
        <script>
            var rdntag = rdntag || {};
            rdntag.cmd = rdntag.cmd || [];
            rdntag.cmd.push(function () {
                rdntag.defineAd("AD_SPOT_ID", 'runa_sdk');
                rdntag.display('runa_sdk');
            });
        </script>
    </body>
</html>
```

### Prepare native WKWebView

The following configurations help optimize the native WKWebView for displaying RUNA ads:

- **Inline Video Playback:**  
  Enable inline playback for video ads.  
  ```swift
  webView.configuration.allowsInlineMediaPlayback = true
  ```

- **Disable Link Preview:**  
  Prevent long press actions on links.  
  ```swift
  webView.allowsLinkPreview = false
  ```

- **Enable Web Inspection:**  
  For iOS 16.4 and above, enable the web inspector to debug the loaded web content.  
  ```swift
  webView.isInspectable = true
  ```

- **Stabilize WKWebView Size:**  
  Disable scrolling and bouncing, and prevent content inset adjustments to maintain a fixed web view size.  
  ```swift
  webView.isScrollEnabled = false
  webView.bounces = false
  webView.contentInsetAdjustmentBehavior = .never
  ```

- **Set a Non-nil Base URL:**  
  When using `loadHTMLString`, provide a valid `baseURL`. This is required for the JS SDK to function correctly.


## Intercepting Click Events

- Implement the `WKNavigationDelegate` protocol.
- Assign the delegate to your WKWebView.
- Override the delegation method `func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void)`
- Detect when an ad is clicked
- cancel the default navigation by calling `decisionHandler(.cancel)` if you handle the event yourself

```swift
if let url = navigationAction.request.url,
    navigationAction.navigationType == .linkActivated {
    // handle action of link clicked
    if interceptLinkActivated(url: url) {
        decisionHandler(.cancel)
    } else {
        decisionHandler(.allow)
    }
} else {
    debugPrint("handleClickBySelf ")
    decisionHandler(.allow)
}
```


## Best Practice
See [gist](https://gist.github.com/wei-b-wu-rakuten/4bb73b80c82ea717b7a16ce61a2e4922) show implementation in WKWebView which intercept ad clicking and open ad link in 3 mode, `sameWebView`, `otherWebView`, `external`.