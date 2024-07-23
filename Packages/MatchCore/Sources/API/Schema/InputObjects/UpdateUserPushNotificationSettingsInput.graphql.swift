// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension API {
  struct UpdateUserPushNotificationSettingsInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      updateUserPushNotificationSettingsInput: [UpdateUserPushNotificationSettingInput]
    ) {
      __data = InputDict([
        "updateUserPushNotificationSettingsInput": updateUserPushNotificationSettingsInput,
      ])
    }

    public var updateUserPushNotificationSettingsInput: [UpdateUserPushNotificationSettingInput] {
      get { __data["updateUserPushNotificationSettingsInput"] }
      set { __data["updateUserPushNotificationSettingsInput"] = newValue }
    }
  }
}
