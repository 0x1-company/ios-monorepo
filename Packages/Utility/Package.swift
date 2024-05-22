// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
  name: "Utility",
  platforms: [
    .iOS(.v16),
  ],
  products: [
    .library(name: "ApolloClientHelpers", targets: ["ApolloClientHelpers"]),
    .library(name: "ApolloConcurrency", targets: ["ApolloConcurrency"]),
    .library(name: "AsyncValue", targets: ["AsyncValue"]),
    .library(name: "ColorHex", targets: ["ColorHex"]),
    .library(name: "StoreKitHelpers", targets: ["StoreKitHelpers"]),
    .library(name: "TcaHelpers", targets: ["TcaHelpers"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios", from: "1.12.0"),
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.26.0"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.10.4"),
  ],
  targets: [
    .target(name: "ApolloClientHelpers", dependencies: [
      .product(name: "Apollo", package: "apollo-ios"),
      .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
    ]),
    .target(name: "ApolloConcurrency", dependencies: [
      .product(name: "Apollo", package: "apollo-ios"),
      .product(name: "ApolloAPI", package: "apollo-ios"),
    ]),
    .target(name: "AsyncValue"),
    .target(name: "ColorHex"),
    .target(name: "StoreKitHelpers", dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "TcaHelpers", dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
  ]
)

package.products.append(
  Product.library(
    name: "UtilityLibrary",
    targets: package.targets.map(\.name)
  )
)
