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
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_1.8.5.xcframework.zip",
			checksum : "8c11ab668c2eee89c320b973355066bc56a869280af9a1a92d4f3193a71a7cdb"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_1.14.4.xcframework.zip",
			checksum : "8f8c83e510e179dee791c8f7306c87e3fba04470acd08af5455ffc3910422f3e"
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
			checksum : "ab4f24310792f2a4b3a8389f1360c1890bfba96d0d1a37f76a909aa05d20f8d1"
        ),
    ]
)
