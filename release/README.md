# Release operation of RUNA iOS SDK

## prepare release resourdes

### gcloud bucket
access to gcloud bucket where the archives are uploaded.

`gcloud auth login`

### distribution definition files
update the version number dependencies.
- Cocoapods
- Carthage
- Swift Package Manager

### create and switch to release branch for [distribution Github](https://github.com/rakuten-ads/Rakuten-Ads-iOS)

`release/1.15.0`

## Steps

### release RUNAOMSDK_Rakuten if need

- zip downloaded iab OMSDK xcframework

`zip -r RUNAOMSDK_iOS_1.4.11.xcframework.zip OMSDK_Rakuten.xcframework -x "*/.DS_Store"`

- get computed md5 and update for SPM

`swift package compute-checksum /Users/wei.b.wu/git/runa/rakuten-ad-ios-test-sample/SDK/OMAdapter/OMSDK/RUNAOMSDK_iOS_1.4.11.xcframework.zip`

- upload to gcloud bucket

`gsutil cp RUNAOMSDK_iOS_1.4.11.xcframework.zip gs://rssp-dev-cdn/sdk/ios/prod/RUNAOMSDK/RUNAOMSDK_iOS_1.4.11.xcframework.zip`

- update cocoapods

`pod repo push Rakuten-Ads-iOS 'release/cocoapods/RUNAOMSDK.podspec' --sources='Rakuten-Ads-iOS' --verbose`

### release Banner, Core, OMAdapter modules

`bundle exec fastlane release module:Core=1.8.0,Banner=1.14.0,OMAdapter=1.3.0 sdk_skip_build:false sdk_dryrun:false`


### update SPM

- update versions in Package.swift
- copy and git push Package.swift

### Create PullRequest

### Publish Github Release