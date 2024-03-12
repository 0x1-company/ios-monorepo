// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class ReadMatchByTargetUserIdMutation: GraphQLMutation {
    public static let operationName: String = "ReadMatchByTargetUserId"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation ReadMatchByTargetUserId($targetUserId: String!) { readMatchByTargetUserId(targetUserId: $targetUserId) { __typename id isRead } }"#
      ))

    public var targetUserId: String

    public init(targetUserId: String) {
      self.targetUserId = targetUserId
    }

    public var __variables: Variables? { ["targetUserId": targetUserId] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("readMatchByTargetUserId", ReadMatchByTargetUserId.self, arguments: ["targetUserId": .variable("targetUserId")]),
      ] }

      /// Matchを既読する
      public var readMatchByTargetUserId: ReadMatchByTargetUserId { __data["readMatchByTargetUserId"] }

      /// ReadMatchByTargetUserId
      ///
      /// Parent Type: `Match`
      public struct ReadMatchByTargetUserId: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Match }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", BeMatch.ID.self),
          .field("isRead", Bool.self),
        ] }

        /// match id
        public var id: BeMatch.ID { __data["id"] }
        /// 既読かどうか
        public var isRead: Bool { __data["isRead"] }
      }
    }
  }
}
