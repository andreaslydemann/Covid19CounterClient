// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Covid19CounterClient",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMinor(from: "3.3.0")),
        .package(url: "https://github.com/vapor/leaf.git", .upToNextMinor(from: "3.0.0")),
        .package(url: "https://github.com/vapor-community/vapor-ext.git", .upToNextMinor(from: "0.3.3"))
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "Leaf", "ServiceExt"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
    ]
)
