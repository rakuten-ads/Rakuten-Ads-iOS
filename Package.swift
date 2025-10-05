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
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_1.8.6.xcframework.zip",
			checksum : "7bf06017eb234594dee7c93e66017f04f520592e89983e22962333eb95a6ee88"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_1.16.0.xcframework.zip",
			checksum : "44cbd7f1c05af9dedbd4a157fcb40b08c375f7034dfcacddc62f6ab83ee633c2"
        ),
        .binaryTarget(
            name: "RUNAOMAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMAdapter/RUNAOMAdapter_iOS_1.3.4.xcframework.zip",
			checksum : "0ce1c4cb185c8107262c5e87e1d3f2b11995b1f4550c72095acc708046c17e09"
        ),
        .binaryTarget(
            name: "OMSDK_Rakuten",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMSDK/RUNAOMSDK_iOS_1.5.2.xcframework.zip",
            checksum : "577e954e53c7ee31a89f413b836423543622ab5d721b32ee74864450409f6a6e"
        ),
        .binaryTarget(
            name: "RUNAMediationAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAMediationAdapter/RUNAMediationAdapter_iOS_1.0.2.xcframework.zip",
			checksum : "ab4f24310792f2a4b3a8389f1360c1890bfba96d0d1a37f76a909aa05d20f8d1"
        ),
    ]
)
