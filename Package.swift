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
            checksum : "18c799d55dc4f968452b283dd359bb5b045ced3617888b2f877c1f9bc35e2674"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/dev/RUNABanner/RUNABanner_iOS_1.9.1.xcframework.zip",
            checksum : "af73de0da0a3bbdb3237a9c3c176c867ee80f87b683a87219559ea835d44a552"
        ),
    ]
)
