// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class PushNotificationBadgeQuery: GraphQLQuery {
    public static let operationName: String = "PushNotificationBadge"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query PushNotificationBadge { pushNotificationBadge { __typename id count } }"#
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("pushNotificationBadge", PushNotificationBadge.self),
      ] }

      public var pushNotificationBadge: PushNotificationBadge { __data["pushNotificationBadge"] }

      /// PushNotificationBadge
      ///
      /// Parent Type: `PushNotificationBadge`
      public struct PushNotificationBadge: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.PushNotificationBadge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("count", Int.self),
        ] }

        public var id: API.ID { __data["id"] }
        /// バッジ数
        public var count: Int { __data["count"] }
      }
    }
  }
}
