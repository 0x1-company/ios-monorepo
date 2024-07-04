// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  struct BannerCard: API.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment BannerCard on Banner { __typename id title description buttonTitle url startAt endAt }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Objects.Banner }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", API.ID.self),
      .field("title", String.self),
      .field("description", String?.self),
      .field("buttonTitle", String.self),
      .field("url", String.self),
      .field("startAt", API.Date.self),
      .field("endAt", API.Date.self),
    ] }

    public var id: API.ID { __data["id"] }
    public var title: String { __data["title"] }
    public var description: String? { __data["description"] }
    public var buttonTitle: String { __data["buttonTitle"] }
    public var url: String { __data["url"] }
    /// 掲載開始時間
    public var startAt: API.Date { __data["startAt"] }
    /// 掲載終了時間
    public var endAt: API.Date { __data["endAt"] }
  }
}
