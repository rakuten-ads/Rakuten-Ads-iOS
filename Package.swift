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
                "RUNAOMAdapter",
            ]
        )
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "RUNACore",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_1.4.5.xcframework.zip",
            checksum : "14a04c8daf65595004027ae830c09c70a1fc6e63995ae2f3b5b149786ed8eba0"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_1.9.1.xcframework.zip",
            checksum : "db1d699ecd2239e537ba2372fecf98783c2d8a84e83f0b00193a38ae5a793db1"
        ),
        .binaryTarget(
            name: "RUNAOMAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMAdapter/RUNAOMAdapter_iOS_1.0.7.xcframework.zip",
            checksum : "3e8ef20acf3ed3514e25130a7b689ea5f66eb1d9cdd608e697597dca950c5c3e"
        ),
    ]
)
