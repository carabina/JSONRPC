// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "JSONRPC",
    products: [
        .library(
            name: "JSONRPC",
            targets: ["JSONRPC"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "JSONRPC",
            dependencies: []),
        .testTarget(
            name: "JSONRPCTests",
            dependencies: ["JSONRPC"]),
    ]
)
