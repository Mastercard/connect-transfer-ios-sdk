// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConnectTransfer",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ConnectTransfer",
            targets: ["ConnectTransferWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/atomicfi/atomic-transact-ios.git", exact: "3.32.0")
    ],
    targets: [
        .binaryTarget(
            name: "ConnectTransfer",
            path: "ConnectTransfer-Dynamic.xcframework"
        ),
        .target(
            name: "ConnectTransferWrapper",
            dependencies: [
                .target(name: "ConnectTransfer"),
                .product(name: "AtomicTransact-Dynamic", package: "atomic-transact-ios"),
            ],
            path: "Sources"
        )
    ]
)
