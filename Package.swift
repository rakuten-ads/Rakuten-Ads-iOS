// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RUNA",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "RUNABanner",
            targets: [
                "Banner",
            ]
        ),
        .library(
            name: "RUNAOMAdapter",
            targets: [
                "OMAdapter",
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "Core",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_1.4.6.xcframework.zip",
            checksum : "a5aae671af5dd526e1ab4cdb4a8bfd411ed38c831b1b67657f90f4cb9000272a"
        ),
        .binaryTarget(
            name: "Banner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_1.9.2.xcframework.zip",
            checksum : "386b76dec8fd0d49a8ae7704809d88aa049f3859caaf02acd9581f19dec73d1d",
            dependencies: [
                "Core"
            ]
        ),
        .binaryTarget(
            name: "OMAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMAdapter/RUNAOMAdapter_iOS_1.0.8.xcframework.zip",
            checksum : "458affe2462cc833f072f69616f1f2faf8b8139f959d959196429fd83fd9790d",
            dependencies: [
                "Banner",
                "OMSDK",
            ]
        ),
        .binaryTarget(
            name: "OMSDK",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMSDK/RUNAOMSDK_iOS_1.3.31.xcframework.zip",
            checksum : "9f5e075651c1c254f6016dd9bc2e8d8e45d6ba2843f8d4c4299e6de6446b31ed"
        ),
    ]
)
