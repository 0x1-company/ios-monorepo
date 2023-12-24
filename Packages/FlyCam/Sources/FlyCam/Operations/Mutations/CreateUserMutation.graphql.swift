// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension FlyCam {
  class CreateUserMutation: GraphQLMutation {
    public static let operationName: String = "CreateUser"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateUser { createUser { __typename ...UserInternal } }"#,
        fragments: [UserInternal.self]
      ))

    public init() {}

    public struct Data: FlyCam.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { FlyCam.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createUser", CreateUser.self),
      ] }

      /// ユーザーを作成する
      public var createUser: CreateUser { __data["createUser"] }

      /// CreateUser
      ///
      /// Parent Type: `User`
      public struct CreateUser: FlyCam.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { FlyCam.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(UserInternal.self),
        ] }

        public var id: FlyCam.ID { __data["id"] }
        public var displayName: String { __data["displayName"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var userInternal: UserInternal { _toFragment() }
        }
      }
    }
  }
}
