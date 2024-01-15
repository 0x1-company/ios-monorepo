// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class MembershipQuery: GraphQLQuery {
    public static let operationName: String = "Membership"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Membership { activeInvitationCampaign { __typename id quantity } invitationCode { __typename id code } currentUser { __typename id } }"#
      ))

    public init() {}

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("activeInvitationCampaign", ActiveInvitationCampaign?.self),
        .field("invitationCode", InvitationCode.self),
        .field("currentUser", CurrentUser.self),
      ] }

      /// 招待キャンペーンを取得
      public var activeInvitationCampaign: ActiveInvitationCampaign? { __data["activeInvitationCampaign"] }
      /// 招待コードを取得
      public var invitationCode: InvitationCode { __data["invitationCode"] }
      /// ログイン中ユーザーを取得
      public var currentUser: CurrentUser { __data["currentUser"] }

      /// ActiveInvitationCampaign
      ///
      /// Parent Type: `InvitationCampaign`
      public struct ActiveInvitationCampaign: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.InvitationCampaign }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", BeMatch.ID.self),
          .field("quantity", Int.self),
        ] }

        public var id: BeMatch.ID { __data["id"] }
        /// 招待キャンペーンの発行数
        public var quantity: Int { __data["quantity"] }
      }

      /// InvitationCode
      ///
      /// Parent Type: `InvitationCode`
      public struct InvitationCode: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.InvitationCode }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", BeMatch.ID.self),
          .field("code", String.self),
        ] }

        public var id: BeMatch.ID { __data["id"] }
        /// 招待コード
        public var code: String { __data["code"] }
      }

      /// CurrentUser
      ///
      /// Parent Type: `User`
      public struct CurrentUser: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", BeMatch.ID.self),
        ] }

        /// user id
        public var id: BeMatch.ID { __data["id"] }
      }
    }
  }
}
