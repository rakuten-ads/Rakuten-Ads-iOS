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
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_1.7.0.xcframework.zip",
			checksum : "9785efa3aefd25019330c33029dd62da84804cc05c035640ac39a36319affea0"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_1.13.0.xcframework.zip",
            checksum : "dfc031fc6f1929e4b95ceecabed09b90e9c6fb816b00310d98acefe2faf71ca1"
        ),
        .binaryTarget(
            name: "RUNAOMAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMAdapter/RUNAOMAdapter_iOS_1.2.0.xcframework.zip",
            checksum : "d80ab79fc780e0a07df7326d3767abf17779caf9d0cb9789b19f6f9e8ddba053"
        ),
        .binaryTarget(
            name: "OMSDK_Rakuten",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMSDK/RUNAOMSDK_iOS_1.4.11.xcframework.zip",
            checksum : "4447450ee4f45c30cf53615f273f2dfda81fada03e79dec9b4f93a8a32e9319c"
        ),
    ]
)
