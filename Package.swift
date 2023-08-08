// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "MyApp",
    platforms: [.macOS(.v12), .iOS(.v15)],
    targets: [
        .executableTarget(
            name: "MyApp",
            path: "Sources"
        ),
    ]
)
