// swift-tools-version:4.0
import PackageDescription

#if os(macOS)
let package = Package(
    name: "JSONRPC",
    products: [
        .library(
            name: "JSONRPC",
            targets: ["JSONRPC"]),
        ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "JSONRPC",
            dependencies: ["Starscream"]),
        .testTarget(
            name: "JSONRPCTests",
            dependencies: ["JSONRPC"]),
        ]
)
#else
let package = Package(
    name: "JSONRPC",
    products: [
        .library(
            name: "JSONRPC",
            targets: ["JSONRPC"]),
        ],
    dependencies: [
        .package(url: "https://github.com/PerfectlySoft/Perfect-CURL", from: "3.0.0"),
        .package(url: "https://github.com/daltoniam/Starscream", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "JSONRPC",
            dependencies: ["PerfectCURL", "Starscream"]),
        .testTarget(
            name: "JSONRPCTests",
            dependencies: ["JSONRPC"]),
        ]
)
#endif
