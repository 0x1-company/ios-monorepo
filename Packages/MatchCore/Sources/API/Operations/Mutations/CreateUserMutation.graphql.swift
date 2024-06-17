// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class CreateUserMutation: GraphQLMutation {
    public static let operationName: String = "CreateUser"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateUser($input: CreateUserInput!) { createUserV2(input: $input) { __typename ...UserInternal } }"#,
        fragments: [PictureSlider.self, UserInternal.self]
      ))

    public var input: CreateUserInput

    public init(input: CreateUserInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createUserV2", CreateUserV2.self, arguments: ["input": .variable("input")]),
      ] }

      /// ユーザーを作成する
      public var createUserV2: CreateUserV2 { __data["createUserV2"] }

      /// CreateUserV2
      ///
      /// Parent Type: `User`
      public struct CreateUserV2: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(UserInternal.self),
        ] }

        /// user id
        public var id: API.ID { __data["id"] }
        public var displayName: String? { __data["displayName"] }
        /// BeRealのusername
        public var berealUsername: String { __data["berealUsername"] }
        /// TapNowのusername
        public var tapnowUsername: String { __data["tapnowUsername"] }
        /// LocketのURL
        public var locketUrl: String { __data["locketUrl"] }
        /// TentenのPINコード
        public var tentenPinCode: String { __data["tentenPinCode"] }
        public var externalProductUrl: String { __data["externalProductUrl"] }
        /// gender
        public var gender: GraphQLEnum<API.Gender> { __data["gender"] }
        public var status: GraphQLEnum<API.UserStatus> { __data["status"] }
        /// ユーザーの画像一覧
        public var images: [Image] { __data["images"] }
        /// 一言コメント
        public var shortComment: ShortComment? { __data["shortComment"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var userInternal: UserInternal { _toFragment() }
          public var pictureSlider: PictureSlider { _toFragment() }
        }

        /// CreateUserV2.Image
        ///
        /// Parent Type: `UserImage`
        public struct Image: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.UserImage }

          public var id: API.ID { __data["id"] }
          public var imageUrl: String { __data["imageUrl"] }
        }

        /// CreateUserV2.ShortComment
        ///
        /// Parent Type: `ShortComment`
        public struct ShortComment: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.ShortComment }

          public var id: API.ID { __data["id"] }
          public var body: String { __data["body"] }
          public var status: GraphQLEnum<API.ShortCommentStatus> { __data["status"] }
        }
      }
    }
  }
}
