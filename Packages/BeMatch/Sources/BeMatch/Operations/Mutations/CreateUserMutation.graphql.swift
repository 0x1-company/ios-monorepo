// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class CreateUserMutation: GraphQLMutation {
    public static let operationName: String = "CreateUser"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateUser { createUser { __typename ...UserInternal } }"#,
        fragments: [PictureSlider.self, UserInternal.self]
      ))

    public init() {}

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createUser", CreateUser.self),
      ] }

      /// ユーザーを作成する
      public var createUser: CreateUser { __data["createUser"] }

      /// CreateUser
      ///
      /// Parent Type: `User`
      public struct CreateUser: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(UserInternal.self),
        ] }

        /// user id
        public var id: BeMatch.ID { __data["id"] }
        /// BeRealのusername
        public var berealUsername: String { __data["berealUsername"] }
        /// gender
        public var gender: GraphQLEnum<BeMatch.Gender> { __data["gender"] }
        public var status: GraphQLEnum<BeMatch.UserStatus> { __data["status"] }
        /// ユーザーの画像一覧
        public var images: [Image] { __data["images"] }
        public var shortComment: ShortComment? { __data["shortComment"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var userInternal: UserInternal { _toFragment() }
          public var pictureSlider: PictureSlider { _toFragment() }
        }

        /// CreateUser.Image
        ///
        /// Parent Type: `UserImage`
        public struct Image: BeMatch.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.UserImage }

          public var id: BeMatch.ID { __data["id"] }
          public var imageUrl: String { __data["imageUrl"] }
        }

        /// CreateUser.ShortComment
        ///
        /// Parent Type: `ShortComment`
        public struct ShortComment: BeMatch.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.ShortComment }

          public var id: BeMatch.ID { __data["id"] }
          public var body: String { __data["body"] }
        }
      }
    }
  }
}
