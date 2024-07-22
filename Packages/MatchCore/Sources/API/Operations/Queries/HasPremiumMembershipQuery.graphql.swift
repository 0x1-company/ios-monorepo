// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class HasPremiumMembershipQuery: GraphQLQuery {
    public static let operationName: String = "HasPremiumMembership"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query HasPremiumMembership { hasPremiumMembership }"#
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("hasPremiumMembership", Bool.self),
      ] }

      /// メンバーシップが有効かどうか
      public var hasPremiumMembership: Bool { __data["hasPremiumMembership"] }
    }
  }
}
