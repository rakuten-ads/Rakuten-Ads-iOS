// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RUNA",
    platforms: [.iOS(.v15)],
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
        .library(
            name: "OMSDK_Rakuten",
            targets: [
                "OMSDK_Rakuten",
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "RUNACore",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNACore/RUNACore_iOS_2.0.0.xcframework.zip",
			checksum : "e3a1833ec52a5d555bd248af844766028a574fe35c1c0087fb330e7497d70976"
        ),
        .binaryTarget(
            name: "RUNABanner",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNABanner/RUNABanner_iOS_2.0.0.xcframework.zip",
			checksum : "5a1a88a91892ba107c8b568b1ef4111ee572d40427919947f5b0d71d9795a28c"
        ),
        .binaryTarget(
            name: "RUNAOMAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMAdapter/RUNAOMAdapter_iOS_2.0.0.xcframework.zip",
			checksum : "df8d79877b90a681f221a069e979cfa23232ccf87a07c3307121d0fce46a89e6"
        ),
        .binaryTarget(
            name: "OMSDK_Rakuten",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAOMSDK/RUNAOMSDK_iOS_1.5.2.xcframework.zip",
            checksum : "577e954e53c7ee31a89f413b836423543622ab5d721b32ee74864450409f6a6e"
        ),
        .binaryTarget(
            name: "RUNAMediationAdapter",
            url: "https://storage.googleapis.com/rssp-dev-cdn/sdk/ios/prod/RUNAMediationAdapter/RUNAMediationAdapter_iOS_2.0.0.xcframework.zip",
			checksum : "013db5209d753797bdd61134c56e2dfffca2e9ac1b0d76d034cb81797859f01a"
        ),
    ]
)
