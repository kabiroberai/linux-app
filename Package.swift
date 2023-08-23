// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "MyApp",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .executable(name: "MyApp", targets: ["MyApp"]),
    ],
    dependencies: [
        .package(path: "child-module"),
        .package(url: "https://github.com/movingparts-io/Pow", from: "0.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "MyApp",
            dependencies: [
                "child-module",
                .product(name: "Pow", package: "Pow", condition: .when(platforms: [.iOS])),
            ],
            resources: [.process("Resources")]
        ),
    ]
)
