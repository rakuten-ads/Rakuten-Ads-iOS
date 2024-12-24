[TOP](/README.md#top)　>　 Manual implementation in standard WKWebView

---

# Manual implementation in standard WKWebView

This document introduces how to load RUNA ad template in a standard WKWebView and handle the event of ad clicking.

## Prerequisite
### OS support

- Xcode 15 above
- iOS 13 above

### Prepare HTML ad template

- import JS SDK `https://s-cdn.rmp.rakuten.co.jp/js/aa.js`
- define the container DIV of banner
- set `AD_SPOT_ID` value configured in web admin console
- enable tag META of viewport in HEAD if necessary

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

The following configurations is recomended to optimize native standard WKWebView for RUNA Ad.

- Show video ad inline in WKWebView
```Swift
webView.configuration.allowsInlineMediaPlayback = true
```

- Disable long press action on links
```Swift
webView.allowsLinkPreview = false
```

- enable web inspect tool above iOS 16.4, like debugging web source in Safari.
```Swift
webView.isInspectable = true
```

- stable size of WKWebView
```Swift
webView.isScrollEnabled = false
webView.bounces = false 
webView.contentInsetAdjustmentBehavior = .never
```

- set a nonnil value to `baseURL` when calling `loadHTMLString`
Parameter `baseURL` is required to embed JS SDK.


## Intercept click event

- implement protocol WKNavigationDelegate
- set navigationDelegate
- override delegation method `func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void)`
- detect and intercept the action of ad clicking
- call `decisionHandler(.cancel)` if handing the transition by self

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