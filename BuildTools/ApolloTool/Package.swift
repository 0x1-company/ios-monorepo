// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ApolloTool",
  platforms: [.macOS(.v10_13)],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios", exact: "1.5.2"),
  ],
  targets: [.target(name: "ApolloTool", path: "")]
)
