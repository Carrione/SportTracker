// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ActivityList",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "ActivityList", targets: ["ActivityList"])
    ],
    dependencies: [
        .package(name: "SharedDomain", path: "../../DomainLayer/SharedDomain"),
        .package(name: "UIToolkit", path: "../UIToolkit"),
        .package(name: "DependencyInjection", path: "../../Application/DependencyInjection")
    ],
    targets: [
        .target(
            name: "ActivityList",
            dependencies: [
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "UIToolkit", package: "UIToolkit"),
                .product(name: "DependencyInjection", package: "DependencyInjection")
            ],
            swiftSettings: [.defaultIsolation(MainActor.self)]
        )
    ]
)
