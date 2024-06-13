// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "iOS.Service.Network",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "iOS.Service.Network",
            targets: ["NetworkService"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.9.1")
    ],
    targets: [
        .target(
            name: "NetworkService",
            dependencies: ["Alamofire"]),
        .testTarget(
            name: "NetworkServiceTests",
            dependencies: ["NetworkService"]),
    ]
)

