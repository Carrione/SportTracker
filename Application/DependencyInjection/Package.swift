// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "DependencyInjection",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "DependencyInjection", targets: ["DependencyInjection"])
    ],
    dependencies: [
        .package(name: "SharedDomain", path: "../../DomainLayer/SharedDomain"),
        .package(name: "ActivityRepository", path: "../../DataLayer/Repositories/ActivityRepository"),
        .package(name: "SwiftDataToolkit", path: "../../DataLayer/Toolkits/SwiftDataToolkit"),
        .package(name: "FirebaseToolkit", path: "../../DataLayer/Toolkits/FirebaseToolkit"),
        .package(name: "SwiftDataProvider", path: "../../DataLayer/Providers/SwiftDataProvider"),
        .package(name: "UIToolkit", path: "../../PresentationLayer/UIToolkit")
    ],
    targets: [
        .target(
            name: "DependencyInjection",
            dependencies: [
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "ActivityRepository", package: "ActivityRepository"),
                .product(name: "SwiftDataToolkit", package: "SwiftDataToolkit"),
                .product(name: "FirebaseToolkit", package: "FirebaseToolkit"),
                .product(name: "SwiftDataProvider", package: "SwiftDataProvider"),
                .product(name: "UIToolkit", package: "UIToolkit")
            ],
            swiftSettings: [.defaultIsolation(MainActor.self)]
        )
    ]
)
