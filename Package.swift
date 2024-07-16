// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "RSRangedDateTimePicker",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "RSRangedDateTimePicker", targets: ["RSRangedDateTimePicker"]),
    ],
    targets: [
        .target(name: "RSRangedDateTimePicker")
    ]
)
