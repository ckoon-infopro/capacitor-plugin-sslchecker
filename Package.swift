// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorPluginSslchecker",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CapacitorPluginSslchecker",
            targets: ["SSLCheckerPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "SSLCheckerPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/SSLCheckerPlugin"),
        .testTarget(
            name: "SSLCheckerPluginTests",
            dependencies: ["SSLCheckerPlugin"],
            path: "ios/Tests/SSLCheckerPluginTests")
    ]
)