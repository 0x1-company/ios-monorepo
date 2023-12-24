// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension FlyCam {
  class PushNotificationBadgeQuery: GraphQLQuery {
    public static let operationName: String = "PushNotificationBadge"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query PushNotificationBadge { pushNotificationBadge { __typename id count } }"#
      ))

    public init() {}

    public struct Data: FlyCam.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { FlyCam.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("pushNotificationBadge", PushNotificationBadge.self),
      ] }

      public var pushNotificationBadge: PushNotificationBadge { __data["pushNotificationBadge"] }

      /// PushNotificationBadge
      ///
      /// Parent Type: `PushNotificationBadge`
      public struct PushNotificationBadge: FlyCam.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { FlyCam.Objects.PushNotificationBadge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", FlyCam.ID.self),
          .field("count", Int.self),
        ] }

        public var id: FlyCam.ID { __data["id"] }
        /// バッジ数
        public var count: Int { __data["count"] }
      }
    }
  }
}
