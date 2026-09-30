// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ActivityRepository",
    platforms: [.iOS(.v26), .macOS(.v14)],
    products: [
        .library(name: "ActivityRepository", targets: ["ActivityRepository"])
    ],
    dependencies: [
        .package(name: "SharedDomain", path: "../../../DomainLayer/SharedDomain")
    ],
    targets: [
        .target(
            name: "ActivityRepository",
            dependencies: [
                .product(name: "SharedDomain", package: "SharedDomain")
            ],
            swiftSettings: [.defaultIsolation(MainActor.self)]
        ),
        .testTarget(
            name: "ActivityRepositoryTests",
            dependencies: ["ActivityRepository"],
            swiftSettings: [.defaultIsolation(MainActor.self)]
        )
    ]
)
