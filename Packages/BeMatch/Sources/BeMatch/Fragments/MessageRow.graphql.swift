// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  struct MessageRow: BeMatch.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment MessageRow on Message { __typename id text userId isAuthor createdAt }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Message }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", BeMatch.ID.self),
      .field("text", String.self),
      .field("userId", BeMatch.ID.self),
      .field("isAuthor", Bool.self),
      .field("createdAt", BeMatch.Date.self),
    ] }

    public var id: BeMatch.ID { __data["id"] }
    public var text: String { __data["text"] }
    public var userId: BeMatch.ID { __data["userId"] }
    public var isAuthor: Bool { __data["isAuthor"] }
    public var createdAt: BeMatch.Date { __data["createdAt"] }
  }
}
