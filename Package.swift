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
        .package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "JSONRPC",
            dependencies: ["PerfectCURL"]),
        .testTarget(
            name: "JSONRPCTests",
            dependencies: ["JSONRPC"]),
    ]
)
