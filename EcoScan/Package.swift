// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "EcoScan",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(name: "EcoScan", targets: ["EcoScan"]),
    ],
    targets: [
        .target(
            name: "EcoScan",
            dependencies: [],
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)
