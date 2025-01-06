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
        .library(
            name: "RUNAMediationAdapter",
            targets: [
                "RUNACore",
                "RUNABanner",
                "RUNAMediationAdapter",
            ]
        ),
        .library(
            name: "OMSDK_Rakuten",
            targets: [
                "OMSDK_Rakuten",
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "RUNACore",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_1.8.5.xcframework.zip",
			checksum : "8c11ab668c2eee89c320b973355066bc56a869280af9a1a92d4f3193a71a7cdb"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_1.15.0.xcframework.zip",
			checksum : "fd3a640c140d230c99e19f12779f6afb4243d8117f389b46ca4dc035069ee7ae"
        ),
        .binaryTarget(
            name: "RUNAOMAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMAdapter/RUNAOMAdapter_iOS_1.3.3.xcframework.zip",
			checksum : "0ce1c4cb185c8107262c5e87e1d3f2b11995b1f4550c72095acc708046c17e09"
        ),
        .binaryTarget(
            name: "OMSDK_Rakuten",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMSDK/RUNAOMSDK_iOS_1.5.2.xcframework.zip",
            checksum : "577e954e53c7ee31a89f413b836423543622ab5d721b32ee74864450409f6a6e"
        ),
        .binaryTarget(
            name: "RUNAMediationAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAMediationAdapter/RUNAMediationAdapter_iOS_1.0.1.xcframework.zip",
			checksum : "ab4f24310792f2a4b3a8389f1360c1890bfba96d0d1a37f76a909aa05d20f8d1"
        ),
    ]
)
