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
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_1.8.1.xcframework.zip",
			checksum : "db07ab7e04b7f33426f59130fcc4a74996681ee27907f1991e428f46608ddc7a"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_1.14.1.xcframework.zip",
			checksum : "ca933f86b355b5ab401f693facfae4b76735825d83f3682abc8f418d3930bf0b"
        ),
        .binaryTarget(
            name: "RUNAOMAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMAdapter/RUNAOMAdapter_iOS_1.3.1.xcframework.zip",
			checksum : "fb56046598777bd19a1b8a3c6a9dfd5b46df54d0bccb352ca4e753ff55d7d644"
        ),
        .binaryTarget(
            name: "OMSDK_Rakuten",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMSDK/RUNAOMSDK_iOS_1.4.12.xcframework.zip",
            checksum : "07e994bfa8f236979d61a2b5c4bff2a2ecaf011a394aaee4c6f71f9f631907c9"
        ),
    ]
)
