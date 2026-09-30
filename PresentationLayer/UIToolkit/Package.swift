// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "UIToolkit",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "UIToolkit", targets: ["UIToolkit"])
    ],
    dependencies: [
        .package(name: "SharedDomain", path: "../../DomainLayer/SharedDomain")
    ],
    targets: [
        .target(
            name: "UIToolkit",
            dependencies: [
                .product(name: "SharedDomain", package: "SharedDomain")
            ],
            swiftSettings: [.defaultIsolation(MainActor.self)]
        )
    ]
)
