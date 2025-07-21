// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "SomeNerts",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(
            name: "SomeNerts",
            targets: ["SomeNerts"]
        ),
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "SomeNerts",
            dependencies: [],
            resources: [
                .process("SomeNerts.xcdatamodeld")
            ]
        ),
    ]
)