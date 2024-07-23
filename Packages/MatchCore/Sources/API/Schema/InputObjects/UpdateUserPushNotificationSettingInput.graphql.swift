// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension API {
  struct UpdateUserPushNotificationSettingInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      allow: Bool,
      pushNotificationKind: GraphQLEnum<PushNotificationKind>
    ) {
      __data = InputDict([
        "allow": allow,
        "pushNotificationKind": pushNotificationKind,
      ])
    }

    public var allow: Bool {
      get { __data["allow"] }
      set { __data["allow"] = newValue }
    }

    public var pushNotificationKind: GraphQLEnum<PushNotificationKind> {
      get { __data["pushNotificationKind"] }
      set { __data["pushNotificationKind"] = newValue }
    }
  }
}
