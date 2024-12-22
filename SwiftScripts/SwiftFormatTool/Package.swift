// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftFormatTool",
  platforms: [.macOS(.v10_13)],
  dependencies: [
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.55.4"),
  ],
  targets: [.target(name: "SwiftFormatTool", path: "")]
)
