// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HapticButton",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "HapticButton",
            targets: ["HapticButton"]),
    ],
    targets: [
        .target(
            name: "HapticButton",
            dependencies: [])
    ]
)
