// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class UpdateUserPushNotificationSettingsMutation: GraphQLMutation {
    public static let operationName: String = "UpdateUserPushNotificationSettings"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateUserPushNotificationSettings($inputs: [UpdateUserPushNotificationSettingInput!]!) { updateUserPushNotificationSettings(inputs: $inputs) { __typename allow pushNotificationKind } }"#
      ))

    public var inputs: [UpdateUserPushNotificationSettingInput]

    public init(inputs: [UpdateUserPushNotificationSettingInput]) {
      self.inputs = inputs
    }

    public var __variables: Variables? { ["inputs": inputs] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateUserPushNotificationSettings", [UpdateUserPushNotificationSetting].self, arguments: ["inputs": .variable("inputs")]),
      ] }

      /// Push通知設定を更新する
      public var updateUserPushNotificationSettings: [UpdateUserPushNotificationSetting] { __data["updateUserPushNotificationSettings"] }

      /// UpdateUserPushNotificationSetting
      ///
      /// Parent Type: `UserPushNotificationSetting`
      public struct UpdateUserPushNotificationSetting: API.SelectionSet {
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
