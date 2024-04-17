// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class ActiveInvitationCampaignQuery: GraphQLQuery {
    public static let operationName: String = "ActiveInvitationCampaign"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query ActiveInvitationCampaign { activeInvitationCampaign { __typename id } }"#
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("activeInvitationCampaign", ActiveInvitationCampaign?.self),
      ] }

      /// 招待キャンペーンを取得
      public var activeInvitationCampaign: ActiveInvitationCampaign? { __data["activeInvitationCampaign"] }

      /// ActiveInvitationCampaign
      ///
      /// Parent Type: `InvitationCampaign`
      public struct ActiveInvitationCampaign: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.InvitationCampaign }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
        ] }

        public var id: API.ID { __data["id"] }
      }
    }
  }
}
