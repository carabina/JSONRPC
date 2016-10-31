import PackageDescription

let package = Package(
    name: "JSONRPC",
    dependencies: [
       .Package(url: "https://github.com/kojirou1994/SFJSON.git", majorVersion: 1, minor: 0)
    ]
)
