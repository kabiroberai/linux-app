// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "MyApp",
    platforms: [.macOS(.v12), .iOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/simibac/ConfettiSwiftUI", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "MyApp",
            dependencies: ["ConfettiSwiftUI"],
            path: "Sources"
        ),
    ]
)
