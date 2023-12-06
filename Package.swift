// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pico-reboot",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(name: "pico-reboot", targets: ["pico-reboot"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "CLibUSB",
            cSettings: [.unsafeFlags(["-I", "Sources/CLibUSB/sources/"])]
        ),
        .executableTarget(
            name: "pico-reboot",
            dependencies: [
                "CLibUSB",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
    ]
)
