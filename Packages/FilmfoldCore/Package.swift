// swift-tools-version: 6.0
import PackageDescription

// All of Filmfold's logic that doesn't need a window lives here, so it can be
// tested with `swift test` on CI. Apple frameworks only; no dependencies.
let package = Package(
    name: "FilmfoldCore",
    platforms: [.macOS("26.0")],
    products: [
        .library(name: "FilmfoldCore", targets: ["FilmfoldCore"])
    ],
    targets: [
        .target(name: "FilmfoldCore"),
        .testTarget(name: "FilmfoldCoreTests", dependencies: ["FilmfoldCore"]),
    ]
)
