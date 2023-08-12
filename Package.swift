// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "MyApp",
    platforms: [.macOS(.v12), .iOS(.v15)],
    targets: [
        .plugin(
            name: "Pack",
            capability: .command(intent: .custom(verb: "pack", description: "Package your target into a .app"))
        ),
        .executableTarget(
            name: "MyApp",
            resources: [.process("Resources")]
        ),
    ]
)
