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
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_1.8.0.xcframework.zip",
			checksum : "9a61185eb755bcfe73bec8f869064e86576dd9ecdff3563151eb8496fa15b621"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_1.14.0.xcframework.zip",
			checksum : "33cc7ee8507a519e456ff62c48ee36c0cf7af92b1c16ae540fe29dd94de03fe3"
        ),
        .binaryTarget(
            name: "RUNAOMAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMAdapter/RUNAOMAdapter_iOS_1.3.0.xcframework.zip",
			checksum : "970ad2d481a91d40dc1634bd10bb61c68476398807c158157d3ef0d574f39846"
        ),
        .binaryTarget(
            name: "OMSDK_Rakuten",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMSDK/RUNAOMSDK_iOS_1.4.11.xcframework.zip",
            checksum : "4447450ee4f45c30cf53615f273f2dfda81fada03e79dec9b4f93a8a32e9319c"
        ),
    ]
)
