// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SharedDomain",
    platforms: [.iOS(.v26), .macOS(.v14)],
    products: [
        .library(name: "SharedDomain", targets: ["SharedDomain"])
    ],
    targets: [
        .target(
            name: "SharedDomain",
            swiftSettings: [.defaultIsolation(MainActor.self)]
        ),
        .testTarget(
            name: "SharedDomainTests",
            dependencies: ["SharedDomain"],
            swiftSettings: [.defaultIsolation(MainActor.self)]
        )
    ]
)
