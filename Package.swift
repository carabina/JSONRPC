// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "JSONRPC",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "JSONRPC",
            targets: ["JSONRPC"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/kojirou1994/JSON.git", from: "0.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "JSONRPC",
            dependencies: []),
        .testTarget(
            name: "JSONRPCTests",
            dependencies: ["JSONRPC"]),
        ]
)
