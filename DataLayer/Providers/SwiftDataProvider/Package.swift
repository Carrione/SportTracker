// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftDataProvider",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "SwiftDataProvider", targets: ["SwiftDataProvider"])
    ],
    dependencies: [
        .package(name: "SwiftDataToolkit", path: "../../Toolkits/SwiftDataToolkit")
    ],
    targets: [
        .target(
            name: "SwiftDataProvider",
            dependencies: [
                .product(name: "SwiftDataToolkit", package: "SwiftDataToolkit")
            ],
            swiftSettings: [.defaultIsolation(MainActor.self)]
        )
    ]
)
