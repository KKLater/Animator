// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Animator",
    products: [
        .library(name: "Animator", targets: ["Animator"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Animator", dependencies: []),
        .testTarget(name: "AnimatorTests", dependencies: ["Animator"]),
    ]
)
