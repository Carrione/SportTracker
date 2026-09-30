// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftDataToolkit",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "SwiftDataToolkit", targets: ["SwiftDataToolkit"])
    ],
    dependencies: [
        .package(name: "SharedDomain", path: "../../../DomainLayer/SharedDomain")
    ],
    targets: [
        .target(
            name: "SwiftDataToolkit",
            dependencies: [
                .product(name: "SharedDomain", package: "SharedDomain")
            ],
            swiftSettings: [.defaultIsolation(MainActor.self)]
        )
    ]
)
