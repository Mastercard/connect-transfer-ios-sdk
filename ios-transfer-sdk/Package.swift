// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConnectTransfer",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ConnectTransfer",
            targets: ["ConnectTransferWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/atomicfi/atomic-transact-ios.git", from: "3.5.20")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(
            name: "ConnectTransfer",
            path: "ConnectTransfer.xcframework"
        ),
        .target(
            name: "ConnectTransferWrapper",
            dependencies: [
                "ConnectTransfer",
                .product(name: "AtomicTransact", package: "atomic-transact-ios"),
            ],
            path: "Sources"
        )
    ]
)
