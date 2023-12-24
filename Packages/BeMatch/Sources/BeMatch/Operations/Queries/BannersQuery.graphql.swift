// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class BannersQuery: GraphQLQuery {
    public static let operationName: String = "Banners"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Banners { banners { __typename ...BannerCard } }"#,
        fragments: [BannerCard.self]
      ))

    public init() {}

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("banners", [Banner].self),
      ] }

      /// バナー一覧
      public var banners: [Banner] { __data["banners"] }

      /// Banner
      ///
      /// Parent Type: `Banner`
      public struct Banner: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Banner }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(BannerCard.self),
        ] }

        public var id: BeMatch.ID { __data["id"] }
        public var title: String { __data["title"] }
        public var description: String? { __data["description"] }
        public var url: String { __data["url"] }
        /// 掲載開始時間
        public var startAt: BeMatch.Date { __data["startAt"] }
        /// 掲載終了時間
        public var endAt: BeMatch.Date { __data["endAt"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var bannerCard: BannerCard { _toFragment() }
        }
      }
    }
  }
}
