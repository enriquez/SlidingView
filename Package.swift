// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SlidingView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "SlidingView", targets: ["SlidingView"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SlidingView", dependencies: []),
        .testTarget(name: "SlidingViewTests", dependencies: ["SlidingView"]),
    ]
)
