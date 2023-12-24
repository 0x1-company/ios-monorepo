// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension FlyCam {
  struct BannerCard: FlyCam.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment BannerCard on Banner { __typename id title description url startAt endAt }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { FlyCam.Objects.Banner }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", FlyCam.ID.self),
      .field("title", String.self),
      .field("description", String?.self),
      .field("url", String.self),
      .field("startAt", FlyCam.Date.self),
      .field("endAt", FlyCam.Date.self),
    ] }

    public var id: FlyCam.ID { __data["id"] }
    public var title: String { __data["title"] }
    public var description: String? { __data["description"] }
    public var url: String { __data["url"] }
    /// 掲載開始時間
    public var startAt: FlyCam.Date { __data["startAt"] }
    /// 掲載終了時間
    public var endAt: FlyCam.Date { __data["endAt"] }
  }
}
