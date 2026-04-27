// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NiceTimer",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "NiceTimer", targets: ["NiceTimer"])
    ],
    targets: [
        .executableTarget(
            name: "NiceTimer",
            path: "Sources/NiceTimer"
        ),
        .testTarget(
            name: "NiceTimerTests",
            dependencies: ["NiceTimer"],
            path: "Tests/NiceTimerTests"
        )
    ]
)
