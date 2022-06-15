// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "AppCore",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "AppCore", targets: ["AppCore"]),
        .library(name: "Helpers", targets: ["Helpers"]),
        .library(name: "Library", targets: ["Library"]),
        .library(name: "Routing", targets: ["Routing"]),
        .library(name: "Feed", targets: ["Feed"])
    ],
    dependencies: [.package(url: "https://github.com/onevcat/Kingfisher", from: "7.2.0")],
    targets: [
        // MARK: - App Core

        .target(name: "AppCore", dependencies: []),
        .testTarget(name: "AppCoreTests", dependencies: ["AppCore"]),

        // MARK: - Domain models

        .target(name: "DomainModels", dependencies: ["Helpers"]),

        // MARK: - Heleprs

        .target(name: "Helpers", dependencies: [.product(name: "Kingfisher", package: "Kingfisher")]),

        // MARK: - Library

        .target(
            name: "Library",
            dependencies: [],
            resources: [
                .copy("Resources/RedHatDisplay-Bold.otf"),
                .copy("Resources/RedHatDisplay-Medium.otf"),
                .copy("Resources/RedHatDisplay-Regular.otf"),
                .copy("Resources/RedHatText-Medium.otf")
            ]
        ),

        // MARK: - Routing

        .target(name: "Routing", dependencies: ["Feed"]),

        // MARK: - Screens

        .target(name: "Feed", dependencies: ["DomainModels", "Helpers"], path: "Sources/Screens")
    ]
)
