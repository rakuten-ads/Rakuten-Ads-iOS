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
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "RUNACore",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_1.8.4.xcframework.zip",
			checksum : "765d7dc1138892245bf5b007e3af26d0f6f85c258cc7ed602ffdc113bdbfe252"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_1.14.4.xcframework.zip",
            checksum : "00fd83c0e19056be9fb11ee5395f067890b41843a8d705a3d970f3a110e9bc68"
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
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAMediationAdapter/RUNAMediationAdapter_iOS_1.0.1.xcframework.zip",
			checksum : "3b7d48b8b66ec3507f80cf0aee51bbd13c1472ba250ead862bbf495f3922552b"
        ),
    ]
)
