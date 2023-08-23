// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "child-module",
    products: [
        .library(
            name: "child-module",
            type: .dynamic,
            targets: ["child-module"]
        ),
    ],
    targets: [
        .target(
            name: "child-module",
            resources: [.copy("Resources/test.txt")]
        ),
    ]
)
