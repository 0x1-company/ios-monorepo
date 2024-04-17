// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class CurrentUserQuery: GraphQLQuery {
    public static let operationName: String = "CurrentUser"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query CurrentUser { currentUser { __typename ...UserInternal } }"#,
        fragments: [PictureSlider.self, UserInternal.self]
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("currentUser", CurrentUser.self),
      ] }

      /// ログイン中ユーザーを取得
      public var currentUser: CurrentUser { __data["currentUser"] }

      /// CurrentUser
      ///
      /// Parent Type: `User`
      public struct CurrentUser: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(UserInternal.self),
        ] }

        /// user id
        public var id: API.ID { __data["id"] }
        /// BeRealのusername
        public var berealUsername: String { __data["berealUsername"] }
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

        /// CurrentUser.Image
        ///
        /// Parent Type: `UserImage`
        public struct Image: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.UserImage }

          public var id: API.ID { __data["id"] }
          public var imageUrl: String { __data["imageUrl"] }
        }

        /// CurrentUser.ShortComment
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
