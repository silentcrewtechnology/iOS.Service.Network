// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "iOS.Service.Network",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "iOS.Service.Network",
            targets: ["NetworkService"]),
    ],
    targets: [
        .target(
            name: "NetworkService"),
        .testTarget(
            name: "NetworkServiceTests",
            dependencies: ["NetworkService"]),
    ]
)

