// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
  name: "swubtitles",
  platforms: [
    .iOS(.v8),
    .macOS(.v10_13)
  ],
  products: [
    .library(name: "swubtitles", targets: ["Fuse"]),
  ],
  targets: [
    .target(name: "Fuse", path: "Fuse")
  ],
  swiftLanguageVersions: [
    .v5
  ]
