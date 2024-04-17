// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  struct MessageRow: API.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment MessageRow on Message { __typename id text userId isAuthor createdAt }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { API.Objects.Message }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", API.ID.self),
      .field("text", String.self),
      .field("userId", API.ID.self),
      .field("isAuthor", Bool.self),
      .field("createdAt", API.Date.self),
    ] }

    public var id: API.ID { __data["id"] }
    public var text: String { __data["text"] }
    public var userId: API.ID { __data["userId"] }
    public var isAuthor: Bool { __data["isAuthor"] }
    public var createdAt: API.Date { __data["createdAt"] }
  }
}
