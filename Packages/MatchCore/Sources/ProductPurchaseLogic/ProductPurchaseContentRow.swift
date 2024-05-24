import ComposableArchitecture
import StoreKit
import SwiftUI

@Reducer
public struct ProductPurchaseContentRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public var id: String

    public let period: Period
    public let price: Decimal
    let currencyCode: String
    public let displayPrice: String?
    public var isSelected: Bool
    public let isMostPopularFlag: Bool

    public var displayPriceWithPeriod: String {
      let formatStyle = Decimal.FormatStyle.Currency(code: currencyCode)
//      switch period {
//      case .oneWeek, .oneMonth:
//        let price = formatStyle.format(price / period.divisor)
//        return String(localized: "\(price) / week", bundle: .module)
//      case .threeMonths, .sixMonths, .twelveMonths:
//        let price = formatStyle.format(price / period.divisor)
//        return String(localized: "\(price) / month", bundle: .module)
//      }
      return formatStyle.format(price)
    }

    public init(
      id: String,
      price: Decimal,
      currencyCode: String,
      displayPrice: String?,
      isSelected: Bool
    ) {
      self.id = id
      period = Period.fromProductIdentifier(id: id)
      self.price = price
      self.currencyCode = currencyCode
      self.displayPrice = displayPrice
      self.isSelected = isSelected
      isMostPopularFlag = isSelected && id.contains("3month")
    }
  }

  public enum Action {
    case onTask
    case rowButtonTapped
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none

      case .rowButtonTapped:
        return .none
      }
    }
  }
}

public extension ProductPurchaseContentRowLogic {
  enum Period: Equatable {
    case oneWeek
    case oneMonth
    case threeMonths
    case sixMonths
    case twelveMonths

    static func fromProductIdentifier(id: String) -> Period {
      if id.contains("1week") {
        return Period.oneWeek
      } else if id.contains("1month") {
        return Period.oneMonth
      } else if id.contains("3month") {
        return Period.threeMonths
      } else if id.contains("6month") {
        return Period.sixMonths
      } else {
        return Period.twelveMonths
      }
    }

    var description: String {
      switch self {
      case .oneWeek:
        return String(localized: "1 Week", bundle: .module)
      case .oneMonth:
        return String(localized: "1 Month", bundle: .module)
      case .threeMonths:
        return String(localized: "3 Months", bundle: .module)
      case .sixMonths:
        return String(localized: "6 Months", bundle: .module)
      case .twelveMonths:
        return String(localized: "12 Months", bundle: .module)
      }
    }

    public var displayName: AttributedString {
      var attributedString = AttributedString(description)
      for digit in "0123456789" {
        if let range = attributedString.range(of: String(digit)) {
          attributedString[range].font = .title.bold()
        }
      }
      return attributedString
    }

    var divisor: Decimal {
      switch self {
      case .oneWeek:
        return 1
      case .oneMonth:
        return 4
      case .threeMonths:
        return 3
      case .sixMonths:
        return 6
      case .twelveMonths:
        return 12
      }
    }
  }
}
