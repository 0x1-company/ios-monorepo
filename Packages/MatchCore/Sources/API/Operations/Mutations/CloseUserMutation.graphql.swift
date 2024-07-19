// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class CloseUserMutation: GraphQLMutation {
    public static let operationName: String = "CloseUser"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CloseUser { closeUser }"#
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("closeUser", Bool.self),
      ] }

      /// アカウントを閉じる
      public var closeUser: Bool { __data["closeUser"] }
    }
  }
}
