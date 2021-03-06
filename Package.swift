// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "LottieUI",
    platforms: [.macOS("10.12"), .iOS(.v10), .tvOS(.v10)],
    products: [
        .library(name: "LottieUI", targets: ["LottieUI"]),
        .library(name: "LottieUITouch", targets: ["LottieUITouch"]),
        .library(name: "LottieUICouch", targets: ["LottieUICouch"])
    ],
    dependencies: [
        .package(url: "https://github.com/clario-tech/lottie-ios.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "LottieUI",
            dependencies: ["Lottie"],
            path: "LottieUI/MacOS"
        ),
        .target(
            name: "LottieUITouch",
            dependencies: ["Lottie"],
            path: "LottieUI/iOS"
        ),
        .target(
            name: "LottieUICouch",
            dependencies: ["Lottie"],
            path: "LottieUI/iOS"
        )
    ]
)
