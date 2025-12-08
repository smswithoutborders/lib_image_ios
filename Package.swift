// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "lib-image-ios",
    platforms: [.macOS(.v14), .iOS("13.0"), .watchOS(.v8)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "lib-image-ios",
            targets: ["lib-image-ios"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ainame/Swift-WebP.git", from: "0.5.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "lib-image-ios",
            dependencies: [
                .product(name: "WebP", package: "Swift-WebP")
            ],
            resources: [.process("Resources")]
        ),

    ]
)
