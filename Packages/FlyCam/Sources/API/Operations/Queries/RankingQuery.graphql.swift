// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class RankingQuery: GraphQLQuery {
    public static let operationName: String = "Ranking"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Ranking { banners { __typename ...BannerCard } rankingsByPost { __typename ...RankingRow } }"#,
        fragments: [BannerCard.self, RankingRow.self]
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("banners", [Banner].self),
        .field("rankingsByPost", [RankingsByPost].self),
      ] }

      /// バナー一覧
      public var banners: [Banner] { __data["banners"] }
      /// 高度順ランキング
      public var rankingsByPost: [RankingsByPost] { __data["rankingsByPost"] }

      /// Banner
      ///
      /// Parent Type: `Banner`
      public struct Banner: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.Banner }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(BannerCard.self),
        ] }

        public var id: API.ID { __data["id"] }
        public var title: String { __data["title"] }
        public var description: String? { __data["description"] }
        public var url: String { __data["url"] }
        /// 掲載開始時間
        public var startAt: API.Date { __data["startAt"] }
        /// 掲載終了時間
        public var endAt: API.Date { __data["endAt"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var bannerCard: BannerCard { _toFragment() }
        }
      }

      /// RankingsByPost
      ///
      /// Parent Type: `Post`
      public struct RankingsByPost: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.Post }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(RankingRow.self),
        ] }

        public var id: API.ID { __data["id"] }
        public var altitude: Double { __data["altitude"] }
        public var videoUrl: String { __data["videoUrl"] }
        public var user: User { __data["user"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var rankingRow: RankingRow { _toFragment() }
        }

        public typealias User = RankingRow.User
      }
    }
  }
}
