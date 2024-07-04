// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class ProductListQuery: GraphQLQuery {
    public static let operationName: String = "ProductList"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query ProductList { productList { __typename membershipProducts { __typename id isMostPopular isRecommended periodKind } } }"#
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("productList", ProductList.self),
      ] }

      /// product一覧を取得
      public var productList: ProductList { __data["productList"] }

      /// ProductList
      ///
      /// Parent Type: `ProductList`
      public struct ProductList: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.ProductList }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("membershipProducts", [MembershipProduct].self),
        ] }

        public var membershipProducts: [MembershipProduct] { __data["membershipProducts"] }

        /// ProductList.MembershipProduct
        ///
        /// Parent Type: `MembershipProduct`
        public struct MembershipProduct: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { API.Objects.MembershipProduct }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", API.ID.self),
            .field("isMostPopular", Bool.self),
            .field("isRecommended", Bool.self),
            .field("periodKind", GraphQLEnum<API.MembershipPeriodKind>.self),
          ] }

          public var id: API.ID { __data["id"] }
          /// 一番人気
          public var isMostPopular: Bool { __data["isMostPopular"] }
          /// デフォルトで選択するもの
          public var isRecommended: Bool { __data["isRecommended"] }
          public var periodKind: GraphQLEnum<API.MembershipPeriodKind> { __data["periodKind"] }
        }
      }
    }
  }
}
