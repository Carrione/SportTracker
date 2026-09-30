// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "FirebaseProvider",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "FirebaseProvider", targets: ["FirebaseProvider"])
    ],
    dependencies: [
        .package(name: "FirebaseToolkit", path: "../../Toolkits/FirebaseToolkit"),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            from: "11.0.0"
        )
    ],
    targets: [
        .target(
            name: "FirebaseProvider",
            dependencies: [
                .product(name: "FirebaseToolkit", package: "FirebaseToolkit"),
                .product(name: "FirebaseCore", package: "firebase-ios-sdk")
            ],
            swiftSettings: [.defaultIsolation(MainActor.self)]
        )
    ]
)
