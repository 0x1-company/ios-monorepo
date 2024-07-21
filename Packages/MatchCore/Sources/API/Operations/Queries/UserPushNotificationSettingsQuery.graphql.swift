// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class UserPushNotificationSettingsQuery: GraphQLQuery {
    public static let operationName: String = "UserPushNotificationSettings"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query UserPushNotificationSettings { userPushNotificationSettings { __typename allow pushNotificationKind } }"#
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("userPushNotificationSettings", [UserPushNotificationSetting].self),
      ] }

      /// Push通知設定を取得する
      public var userPushNotificationSettings: [UserPushNotificationSetting] { __data["userPushNotificationSettings"] }

      /// UserPushNotificationSetting
      ///
      /// Parent Type: `UserPushNotificationSetting`
      public struct UserPushNotificationSetting: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.UserPushNotificationSetting }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("allow", Bool.self),
          .field("pushNotificationKind", GraphQLEnum<API.PushNotificationKind>.self),
        ] }

        public var allow: Bool { __data["allow"] }
        public var pushNotificationKind: GraphQLEnum<API.PushNotificationKind> { __data["pushNotificationKind"] }
      }
    }
  }
}
