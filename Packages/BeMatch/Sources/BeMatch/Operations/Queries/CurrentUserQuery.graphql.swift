// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class CurrentUserQuery: GraphQLQuery {
    public static let operationName: String = "CurrentUser"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query CurrentUser { currentUser { __typename ...UserInternal } }"#,
        fragments: [PictureSliderImage.self, UserInternal.self]
      ))

    public init() {}

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("currentUser", CurrentUser.self),
      ] }

      /// ログイン中ユーザーを取得
      public var currentUser: CurrentUser { __data["currentUser"] }

      /// CurrentUser
      ///
      /// Parent Type: `User`
      public struct CurrentUser: BeMatch.SelectionSet {
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

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var userInternal: UserInternal { _toFragment() }
        }

        /// CurrentUser.Image
        ///
        /// Parent Type: `UserImage`
        public struct Image: BeMatch.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.UserImage }

          public var id: BeMatch.ID { __data["id"] }
          public var imageUrl: String { __data["imageUrl"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var pictureSliderImage: PictureSliderImage { _toFragment() }
          }
        }
      }
    }
  }
}
