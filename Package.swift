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
                // "RUNABanner",
            ]
        )
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "RUNACore",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/dev/RUNACore/RUNACore_iOS_1.5.0.xcframework.zip",
            checksum : "a4fe86a3df367913022b2c6ad56ca383c94046701abd9b140f396cecddf39d10"
        ),
        // .binaryTarget(
        //     name: "RUNABanner",
        //     url: "",
        //     checksum : ""
        // ),
    ]
)
