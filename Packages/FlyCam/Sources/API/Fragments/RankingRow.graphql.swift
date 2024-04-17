// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  struct RankingRow: API.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment RankingRow on Post { __typename id altitude videoUrl user { __typename id displayName } }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { API.Objects.Post }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", API.ID.self),
      .field("altitude", Double.self),
      .field("videoUrl", String.self),
      .field("user", User.self),
    ] }

    public var id: API.ID { __data["id"] }
    public var altitude: Double { __data["altitude"] }
    public var videoUrl: String { __data["videoUrl"] }
    public var user: User { __data["user"] }

    /// User
    ///
    /// Parent Type: `User`
    public struct User: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", API.ID.self),
        .field("displayName", String.self),
      ] }

      public var id: API.ID { __data["id"] }
      public var displayName: String { __data["displayName"] }
    }
  }
}
