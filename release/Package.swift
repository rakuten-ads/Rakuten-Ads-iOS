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
                "RUNAMediationAdapter",
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "RUNACore",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_1.8.2.xcframework.zip",
			checksum : "305fed8674362ffdda2e29403f45aaf6fab0a402d4dc0686cd25417ede4ebb58"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_1.14.2.xcframework.zip",
			checksum : "308a6e7d746fdf52b9113887735ff48a7c0c509baefbdc8171142c593fcc285a"
        ),
        .binaryTarget(
            name: "RUNAOMAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMAdapter/RUNAOMAdapter_iOS_1.3.2.xcframework.zip",
			checksum : "221e2e02b8db0e84b1af5e8a6c9b3c403e858a81d4b69bedacc520c421d880d5"
        ),
        .binaryTarget(
            name: "OMSDK_Rakuten",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMSDK/RUNAOMSDK_iOS_1.4.13.xcframework.zip",
            checksum : "180907f36fd797969839123a4845a7e929af7ee7f2f51326419e3060fef551e0"
        ),
        .binaryTarget(
            name: "RUNAMediationAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAMediationAdapter/RUNAMediationAdapter_iOS_1.0.0.xcframework.zip",
			checksum : "a88b304ba91a96d129d93ce5fe7af5297a53de0daf6123b9d0dd3ca4f8f1d1f7"
        ),
    ]
)
