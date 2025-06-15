// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Copyright (c) 2025 Tadashi Kimura
// SPDX-License-Identifier: MIT

import PackageDescription

let package = Package(
    name: "SimIdleSkill",
    platforms: [
        .iOS("18.0")
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SimIdleApp",
            targets: ["SimIdleApp"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SimIdleApp",
            dependencies: ["SimIdleExperience", "SimIdleShare"],
            path: "Sources/App"),
        .target(
            name: "SimIdleExperience",
            path: "Sources/Experience"),
        .target(
            name: "SimIdleShare",
            path: "Sources/Share"),
        .testTarget(
            name: "SimIdleExperienceTests",
            dependencies: ["SimIdleExperience"],
            path: "Tests/ExperienceTests"
        ),
        .testTarget(
            name: "SimIdleShareTests",
            dependencies: ["SimIdleShare"],
            path: "Tests/ShareTests"
        ),
    ]
)
