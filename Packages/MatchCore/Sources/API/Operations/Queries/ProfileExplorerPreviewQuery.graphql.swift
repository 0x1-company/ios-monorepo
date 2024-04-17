// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class ProfileExplorerPreviewQuery: GraphQLQuery {
    public static let operationName: String = "ProfileExplorerPreview"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query ProfileExplorerPreview($targetUserId: String!) { userByMatched(targetUserId: $targetUserId) { __typename id berealUsername ...PictureSlider } }"#,
        fragments: [PictureSlider.self]
      ))

    public var targetUserId: String

    public init(targetUserId: String) {
      self.targetUserId = targetUserId
    }

    public var __variables: Variables? { ["targetUserId": targetUserId] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("userByMatched", UserByMatched.self, arguments: ["targetUserId": .variable("targetUserId")]),
      ] }

      /// マッチしたユーザーを取得
      public var userByMatched: UserByMatched { __data["userByMatched"] }

      /// UserByMatched
      ///
      /// Parent Type: `User`
      public struct UserByMatched: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("berealUsername", String.self),
          .fragment(PictureSlider.self),
        ] }

        /// user id
        public var id: API.ID { __data["id"] }
        /// BeRealのusername
        public var berealUsername: String { __data["berealUsername"] }
        /// 一言コメント
        public var shortComment: ShortComment? { __data["shortComment"] }
        /// ユーザーの画像一覧
        public var images: [Image] { __data["images"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var pictureSlider: PictureSlider { _toFragment() }
        }

        public typealias ShortComment = PictureSlider.ShortComment

        public typealias Image = PictureSlider.Image
      }
    }
  }
}
