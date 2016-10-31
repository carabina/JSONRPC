import PackageDescription

let package = Package(
    name: "JSONRPC",
    dependencies: [
       .Package(url: "https://github.com/kojirou1994/JSON.git", majorVersion: 0, minor: 1)
    ]
)
