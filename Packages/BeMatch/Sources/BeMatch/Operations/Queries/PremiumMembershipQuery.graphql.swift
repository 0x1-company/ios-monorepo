// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class PremiumMembershipQuery: GraphQLQuery {
    public static let operationName: String = "PremiumMembership"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query PremiumMembership { premiumMembership { __typename id expireAt appleSubscriptionId invitationCampaignUseId } }"#
      ))

    public init() {}

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("premiumMembership", PremiumMembership?.self),
      ] }

      /// プレミアムメンバーシップ情報
      public var premiumMembership: PremiumMembership? { __data["premiumMembership"] }

      /// PremiumMembership
      ///
      /// Parent Type: `PremiumMembership`
      public struct PremiumMembership: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.PremiumMembership }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", BeMatch.ID.self),
          .field("expireAt", BeMatch.Date.self),
          .field("appleSubscriptionId", String?.self),
          .field("invitationCampaignUseId", String?.self),
        ] }

        public var id: BeMatch.ID { __data["id"] }
        public var expireAt: BeMatch.Date { __data["expireAt"] }
        public var appleSubscriptionId: String? { __data["appleSubscriptionId"] }
        public var invitationCampaignUseId: String? { __data["invitationCampaignUseId"] }
      }
    }
  }
}
