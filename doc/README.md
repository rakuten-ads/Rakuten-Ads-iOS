<div id="top"></div>

![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)
![language](http://img.shields.io/badge/language-ObjC-brightgreen.svg?style=flat)

---

# RUNA SDK Document for 1.x
Welcome to the RUNA SDK documentation for version 1.x. This version was launched in 2019 and is currently maintained. It is built in Objective-C.

For the implementation on SDK version __2.x__ which is built in Swift, please refer to [the document of 2.x](../doc2/README.md).

This index provides links to detailed manuals for each major feature and integration pattern. Click on a section to view its dedicated guide.

## Table of Contents

- **[Banner Ad](./doc/bannerads/README.md)**
- **[CarouselAds](./doc/bannerads/carousel/README.md)**
- **[Interstitial Ad](./doc/interstitial/README.md)**
- **[Viewability Measurement](./doc/measurement/README.md)**
- **[MediationAdapter](./doc/mediation/README.md)**

## [Integrate SDK](#integrate-sdk)

### [CocoaPods](#cocoapods)

Put under lines into `Podfile`.

```ruby
source "https://github.com/rakuten-ads/Rakuten-Ads-iOS"

pod 'RUNA/Banner'
pod 'RUNA/OMAdapter'
```

### [M1 support](#m1-support)

RUNA SDK starts to support xcframework from 1.10.1.

The implemenation for any past version in M1 Macbook, it is need to set `EXCLUDED_ARCHS[sdk=iphonesimulator*] = "arm64 armv7"` in Build Settings, or add a `post_install` hook for in `Podfile` like below.

```ruby
target 'App' do
  post_install do |installer|
    installer.pods_project.build_configurations.each do |configuration|
      configuration.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64 armv7"
    end
  end
end
```
---

For further assistance, rise a Github issue or contact support.

LANGUAGE :
> [![jp](./doc/lang/ja.png)](./doc/ja)