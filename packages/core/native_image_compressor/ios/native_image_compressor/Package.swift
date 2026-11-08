// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "native_image_compressor",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "native-image-compressor", targets: ["native_image_compressor"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "native_image_compressor",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
