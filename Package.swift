// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RUNA",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "RUNABanner",
            targets: [
                "RUNACore",
                "RUNABanner",
            ]
        ),
        .library(
            name: "RUNAOMAdapter",
            targets: [
                "RUNACore",
                "RUNABanner",
                "RUNAOMAdapter",
                "OMSDK_Rakuten",
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "RUNACore",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_1.6.0.xcframework.zip",
            checksum : "f70d0cbb0c6371153b08202515ed437f345ed5d241dc717779ff939ce1836dbd"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_1.12.0.xcframework.zip",
            checksum : "e131a57f1938dab68bdb3bb80bb81ebb98e38b3c29ab5a44d19fd6862fbfde74"
        ),
        .binaryTarget(
            name: "RUNAOMAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMAdapter/RUNAOMAdapter_iOS_1.1.0.xcframework.zip",
            checksum : "86ac3e2d721db35c9f45e1cf63b81f26bf1dde3f756b55026fde0d60a56919c8"
        ),
        .binaryTarget(
            name: "OMSDK_Rakuten",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMSDK/RUNAOMSDK_iOS_1.4.3.xcframework.zip",
            checksum : "aa5a99ae1f1b64bac66b0beffa2aaadc8920842c3706aeb7e0508b19d29d70d5"
        ),
    ]
)
