// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class InvitationCodeQuery: GraphQLQuery {
    public static let operationName: String = "InvitationCode"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query InvitationCode { invitationCode { __typename id code } }"#
      ))

    public init() {}

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("invitationCode", InvitationCode.self),
      ] }

      /// 招待コードを取得
      public var invitationCode: InvitationCode { __data["invitationCode"] }

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
    }
  }
}
