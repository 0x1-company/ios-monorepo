// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class AchievementQuery: GraphQLQuery {
    public static let operationName: String = "Achievement"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Achievement { achievement { __typename id visitCount matchCount feedbackCount consecutiveLoginDayCount } }"#
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("achievement", Achievement.self),
      ] }

      public var achievement: Achievement { __data["achievement"] }

      /// Achievement
      ///
      /// Parent Type: `Achievement`
      public struct Achievement: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.Achievement }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("visitCount", Int.self),
          .field("matchCount", Int.self),
          .field("feedbackCount", Int.self),
          .field("consecutiveLoginDayCount", Int.self),
        ] }

        public var id: API.ID { __data["id"] }
        public var visitCount: Int { __data["visitCount"] }
        public var matchCount: Int { __data["matchCount"] }
        public var feedbackCount: Int { __data["feedbackCount"] }
        public var consecutiveLoginDayCount: Int { __data["consecutiveLoginDayCount"] }
      }
    }
  }
}
