// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class ActivePremiumMembershipsQuery: GraphQLQuery {
    public static let operationName: String = "ActivePremiumMemberships"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query ActivePremiumMemberships { activePremiumMemberships { __typename id expireAt } }"#
      ))

    public init() {}

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("activePremiumMemberships", [ActivePremiumMembership].self),
      ] }

      /// 期限内のメンバーシップを取得
      public var activePremiumMemberships: [ActivePremiumMembership] { __data["activePremiumMemberships"] }

      /// ActivePremiumMembership
      ///
      /// Parent Type: `PremiumMembership`
      public struct ActivePremiumMembership: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.PremiumMembership }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", BeMatch.ID.self),
          .field("expireAt", BeMatch.Date.self),
        ] }

        public var id: BeMatch.ID { __data["id"] }
        public var expireAt: BeMatch.Date { __data["expireAt"] }
      }
    }
  }
}
