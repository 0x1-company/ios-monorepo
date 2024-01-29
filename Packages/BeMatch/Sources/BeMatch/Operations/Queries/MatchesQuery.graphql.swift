// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class MatchesQuery: GraphQLQuery {
    public static let operationName: String = "Matches"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Matches($first: Int!, $after: String) { matches(first: $first, after: $after) { __typename pageInfo { __typename ...NextPagination } edges { __typename node { __typename ...MatchGrid } } } }"#,
        fragments: [MatchGrid.self, NextPagination.self, PictureSlider.self]
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
          .field("pageInfo", PageInfo.self),
          .field("edges", [Edge].self),
        ] }

        public var pageInfo: PageInfo { __data["pageInfo"] }
        public var edges: [Edge] { __data["edges"] }

        /// Matches.PageInfo
        ///
        /// Parent Type: `PageInfo`
        public struct PageInfo: BeMatch.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.PageInfo }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(NextPagination.self),
          ] }

          /// 次のページがあるかどうか
          public var hasNextPage: Bool { __data["hasNextPage"] }
          /// 最後のedgeのカーソル
          public var endCursor: String? { __data["endCursor"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var nextPagination: NextPagination { _toFragment() }
          }
        }

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
            public var targetUser: TargetUser { __data["targetUser"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var matchGrid: MatchGrid { _toFragment() }
            }

            /// Matches.Edge.Node.TargetUser
            ///
            /// Parent Type: `User`
            public struct TargetUser: BeMatch.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }

              /// user id
              public var id: BeMatch.ID { __data["id"] }
              /// BeRealのusername
              public var berealUsername: String { __data["berealUsername"] }
              /// 一言コメント
              public var shortComment: ShortComment? { __data["shortComment"] }
              /// ユーザーの画像一覧
              public var images: [Image] { __data["images"] }

              public struct Fragments: FragmentContainer {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public var pictureSlider: PictureSlider { _toFragment() }
              }

              public typealias ShortComment = PictureSlider.ShortComment

              public typealias Image = PictureSlider.Image
            }
          }
        }
      }
    }
  }
}
