// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ApolloTool",
  platforms: [
    .macOS(.v12),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    .package(url: "https://github.com/apollographql/apollo-ios-codegen", from: "1.7.1"),
  ],
  targets: [
    .target(name: "SwiftScriptHelpers"),
    .executableTarget(name: "Codegen", dependencies: [
      "SwiftScriptHelpers",
      .product(name: "ApolloCodegenLib", package: "apollo-ios-codegen"),
      .product(name: "ArgumentParser", package: "swift-argument-parser"),
    ]),
  ]
)
