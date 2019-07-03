// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "PullToRefreshKit",
    products: [
        .library(name: "PullToRefreshKit", targets: ["PullToRefreshKit"]),
    ],
    targets: [
        .target(name: "PullToRefreshKit"),
//        .testTarget(name: "PullToRefreshKitTests", dependencies: ["PullToRefreshKit"])
    ],
    swiftLanguageVersions: [
        .v4,.v4_2,.v5
    ]
)
