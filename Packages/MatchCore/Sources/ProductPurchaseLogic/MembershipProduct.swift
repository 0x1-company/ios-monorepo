import API
import Foundation
import StoreKit

public struct MembershipProduct: Equatable {
  public let appleProduct: StoreKit.Product

    public var id: String {
        appleProduct.id
    }

    let isRecommended: Bool
    let isMostPopular: Bool

    init(appleProduct: StoreKit.Product, data: API.ProductListQuery.Data.ProductList.MembershipProduct?) {
        self.appleProduct = appleProduct
        self.isRecommended = data?.isRecommended ?? false
        self.isMostPopular = data?.isMostPopular ?? false
    }
}
