// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class MembershipQuery: GraphQLQuery {
    public static let operationName: String = "Membership"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Membership { activeInvitationCampaign { __typename id quantity durationWeeks } invitationCode { __typename id code } }"#
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("activeInvitationCampaign", ActiveInvitationCampaign?.self),
        .field("invitationCode", InvitationCode.self),
      ] }

      /// 招待キャンペーンを取得
      public var activeInvitationCampaign: ActiveInvitationCampaign? { __data["activeInvitationCampaign"] }
      /// 招待コードを取得
      public var invitationCode: InvitationCode { __data["invitationCode"] }

      /// ActiveInvitationCampaign
      ///
      /// Parent Type: `InvitationCampaign`
      public struct ActiveInvitationCampaign: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.InvitationCampaign }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("quantity", Int.self),
          .field("durationWeeks", Int.self),
        ] }

        public var id: API.ID { __data["id"] }
        /// 招待キャンペーンの発行数
        public var quantity: Int { __data["quantity"] }
        /// 何週間メンバーシップを付与するのか
        public var durationWeeks: Int { __data["durationWeeks"] }
      }

      /// InvitationCode
      ///
      /// Parent Type: `InvitationCode`
      public struct InvitationCode: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.InvitationCode }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("code", String.self),
        ] }

        public var id: API.ID { __data["id"] }
        /// 招待コード
        public var code: String { __data["code"] }
      }
    }
  }
}
