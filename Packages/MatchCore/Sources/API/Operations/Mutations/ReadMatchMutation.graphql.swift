// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class ReadMatchMutation: GraphQLMutation {
    public static let operationName: String = "ReadMatch"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation ReadMatch($matchId: String!) { readMatch(matchId: $matchId) { __typename id isRead } }"#
      ))

    public var matchId: String

    public init(matchId: String) {
      self.matchId = matchId
    }

    public var __variables: Variables? { ["matchId": matchId] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("readMatch", ReadMatch.self, arguments: ["matchId": .variable("matchId")]),
      ] }

      /// Matchを既読にする
      public var readMatch: ReadMatch { __data["readMatch"] }

      /// ReadMatch
      ///
      /// Parent Type: `Match`
      public struct ReadMatch: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.Match }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("isRead", Bool.self),
        ] }

        /// match id
        public var id: API.ID { __data["id"] }
        /// 既読かどうか
        public var isRead: Bool { __data["isRead"] }
      }
    }
  }
}
