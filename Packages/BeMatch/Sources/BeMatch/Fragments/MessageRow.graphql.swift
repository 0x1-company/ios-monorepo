// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  struct MessageRow: BeMatch.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment MessageRow on Message { __typename id text createdAt }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Message }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", BeMatch.ID.self),
      .field("text", String.self),
      .field("createdAt", BeMatch.Date.self),
    ] }

    /// direct message id
    public var id: BeMatch.ID { __data["id"] }
    /// message content
    public var text: String { __data["text"] }
    /// When the message is created
    public var createdAt: BeMatch.Date { __data["createdAt"] }
  }
}
