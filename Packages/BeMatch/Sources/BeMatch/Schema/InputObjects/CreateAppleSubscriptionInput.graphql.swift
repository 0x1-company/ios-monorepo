// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension BeMatch {
  struct CreateAppleSubscriptionInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      environment: GraphQLEnum<AppleSubscriptionEnvironment>,
      transactionId: String
    ) {
      __data = InputDict([
        "environment": environment,
        "transactionId": transactionId,
      ])
    }

    public var environment: GraphQLEnum<AppleSubscriptionEnvironment> {
      get { __data["environment"] }
      set { __data["environment"] = newValue }
    }

    public var transactionId: String {
      get { __data["transactionId"] }
      set { __data["transactionId"] = newValue }
    }
  }
}
