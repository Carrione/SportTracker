// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "FirebaseToolkit",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "FirebaseToolkit", targets: ["FirebaseToolkit"])
    ],
    dependencies: [
        .package(name: "SharedDomain", path: "../../../DomainLayer/SharedDomain"),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            from: "11.0.0"
        ),
        .package(
            url: "https://github.com/google/GoogleSignIn-iOS",
            from: "8.0.0"
        )
    ],
    targets: [
        .target(
            name: "FirebaseToolkit",
            dependencies: [
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
            ],
            swiftSettings: [.defaultIsolation(MainActor.self)]
        )
    ]
)
