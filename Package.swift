// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RUNA",
    platforms: [.iOS(.v10)],
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
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_1.5.0.xcframework.zip",
            checksum : "0b087ba8ac8cb4386e43fb1676421af49659100ee5ecaad1d81ca58bbe6bc7bb"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_1.10.0.xcframework.zip",
            checksum : "7e20388c2dc88da96b6a8265b417d3be109620ac1066fd5cedb9f28d1b1fe13d"
        ),
        .binaryTarget(
            name: "RUNAOMAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMAdapter/RUNAOMAdapter_iOS_1.0.8.xcframework.zip",
            checksum : "458affe2462cc833f072f69616f1f2faf8b8139f959d959196429fd83fd9790d"
        ),
        .binaryTarget(
            name: "OMSDK_Rakuten",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMSDK/RUNAOMSDK_iOS_1.3.31.xcframework.zip",
            checksum : "9f5e075651c1c254f6016dd9bc2e8d8e45d6ba2843f8d4c4299e6de6446b31ed"
        ),
    ]
)
