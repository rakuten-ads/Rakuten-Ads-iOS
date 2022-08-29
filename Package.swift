// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RUNA",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "RUNA",
            targets: [
                "RUNACore", 
                "RUNABanner",
            ]
        )
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "RUNACore",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/dev/RUNACore/RUNACore_iOS_1.4.5.xcframework.zip",
            checksum : "0bad5054c7c8f2d98406cdcee1a8864ac48b7771191d3ea435ac5f17c33de9f7"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/dev/RUNABanner/RUNABanner_iOS_1.9.1.xcframework.zip",
            checksum : "3fdfec11d0c1a822e04435ea1d64fcff137693a851acffe3516b7fa8e4f30589"
        ),
    ]
)
