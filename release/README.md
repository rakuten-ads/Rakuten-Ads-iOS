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

`release/1.15.2`

## Steps before scripts

0. Update version numbers for all modules in Xcode BuildSettings

0. Update version number for the integrated RUNASDK in the source file `RUNABannerViewInner.m` of module Banner

0. Update version numbers in cocoapods podspec files, carthage json files, SPM `Package.swift` file


### release RUNAOMSDK_Rakuten if need

`REL_VER=1.14.3`

- code signing for OMSDK xcframework (current certificate expire until 2024/05/23)
`codesign -f -s 7899E12F3631575BECF6FFDD56466B2196411C3B OMSDK_Rakuten.xcframework`

- zip downloaded iab OMSDK xcframework 
`zip -r RUNAOMSDK_iOS_${REL_VER}.xcframework.zip OMSDK_Rakuten.xcframework -x "*/.DS_Store"`

- get computed md5 and update for SPM

`swift package compute-checksum /Users/wei.b.wu/git/runa/rakuten-ad-ios-test-sample/SDK/OMAdapter/OMSDK/RUNAOMSDK_iOS_${REL_VER}.xcframework.zip`

- upload to gcloud bucket

`gsutil cp RUNAOMSDK_iOS_${REL_VER}.xcframework.zip gs://rssp-dev-cdn/sdk/ios/prod/RUNAOMSDK/RUNAOMSDK_iOS_${REL_VER}.xcframework.zip`

- update cocoapods

`pod repo push Rakuten-Ads-iOS 'release/cocoapods/RUNAOMSDK.podspec' --sources='Rakuten-Ads-iOS' --verbose`

### release Banner, Core, OMAdapter modules

`bundle exec fastlane release module:Core=1.8.1,Banner=1.14.1,OMAdapter=1.3.1 sdk_skip_build:false sdk_dryrun:false`


### Create PullRequest

### Publish Github Release