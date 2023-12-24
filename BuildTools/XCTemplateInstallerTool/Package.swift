// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "XCTemplateInstallerTool",
  platforms: [.macOS(.v10_13)],
  dependencies: [
    .package(url: "https://github.com/noppefoxwolf/XCTemplateInstaller", from: "1.0.6"),
  ],
  targets: [.target(name: "XCTemplateInstallerTool", path: "")]
)
