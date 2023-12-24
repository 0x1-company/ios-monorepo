// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class MatchesQuery: GraphQLQuery {
    public static let operationName: String = "Matches"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Matches($first: Int!, $after: String) { matches(first: $first, after: $after) { __typename edges { __typename node { __typename ...MatchGrid } } } }"#,
        fragments: [MatchGrid.self, ProfilePhoto.self]
      ))

    public var first: Int
    public var after: GraphQLNullable<String>

    public init(
      first: Int,
      after: GraphQLNullable<String>
    ) {
      self.first = first
      self.after = after
    }

    public var __variables: Variables? { [
      "first": first,
      "after": after,
    ] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("matches", Matches.self, arguments: [
          "first": .variable("first"),
          "after": .variable("after"),
        ]),
      ] }

      /// マッチ一覧
      public var matches: Matches { __data["matches"] }

      /// Matches
      ///
      /// Parent Type: `MatchConnection`
      public struct Matches: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.MatchConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("edges", [Edge].self),
        ] }

        public var edges: [Edge] { __data["edges"] }

        /// Matches.Edge
        ///
        /// Parent Type: `MatchEdge`
        public struct Edge: BeMatch.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.MatchEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", Node.self),
          ] }

          public var node: Node { __data["node"] }

          /// Matches.Edge.Node
          ///
          /// Parent Type: `Match`
          public struct Node: BeMatch.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Match }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(MatchGrid.self),
            ] }

            /// match id
            public var id: BeMatch.ID { __data["id"] }
            public var createdAt: BeMatch.Date { __data["createdAt"] }
            /// 既読かどうか
            public var isRead: Bool { __data["isRead"] }
            /// マッチした相手
            public var targetUser: MatchGrid.TargetUser { __data["targetUser"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var matchGrid: MatchGrid { _toFragment() }
            }
          }
        }
      }
    }
  }
}
