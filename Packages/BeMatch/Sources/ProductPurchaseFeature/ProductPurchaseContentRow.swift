import ComposableArchitecture
import ProductPurchaseLogic
import Styleguide
import SwiftUI
import StoreKit

public struct ProductPurchaseContentRowView: View {
  let store: StoreOf<ProductPurchaseContentRowLogic>

  public init(store: StoreOf<ProductPurchaseContentRowLogic>) {
    self.store = store
  }
  
  func applyAttributedString(displayName: String) -> AttributedString {
    var attributedString = AttributedString(displayName)
    for digit in "0123456789" {
      if let range = attributedString.range(of: String(digit)) {
        attributedString[range].font = .title.bold()
      }
    }
    return attributedString
  }

  func formatPriceAsCurrency(currencyCode: String, price: Decimal, divisor: Decimal) -> String {
      let formatStyle = Decimal.FormatStyle.Currency(code: currencyCode)
      return formatStyle.format(price / divisor)
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        store.send(.rowButtonTapped, animation: .default)
      } label: {
        HStack(spacing: 0) {
          Text(applyAttributedString(displayName: viewStore.displayName))
            .font(.headline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)

          VStack(alignment: .trailing, spacing: 4) {
            if let displayPrice = viewStore.displayPrice {
              Text(displayPrice)
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(Color.secondary)
                .overlay(alignment: .center) {
                  Color.secondary
                    .frame(height: 2)
                }
            }

            Group {
              if viewStore.id.contains("1week") {
                let price = Decimal.FormatStyle.Currency(code: viewStore.currencyCode).format(viewStore.price)
                Text("\(price) / week", bundle: .module)
              } else if viewStore.id.contains("1month") {
                let price = formatPriceAsCurrency(currencyCode: viewStore.currencyCode, price: viewStore.price, divisor: 4)
                Text("\(price) / week", bundle: .module)
              } else if viewStore.id.contains("3month") {
                let price = formatPriceAsCurrency(currencyCode: viewStore.currencyCode, price: viewStore.price, divisor: 3)
                Text("\(price) / month", bundle: .module)
              } else if viewStore.id.contains("6month") {
                let price = formatPriceAsCurrency(currencyCode: viewStore.currencyCode, price: viewStore.price, divisor: 6)
                Text("\(price) / month", bundle: .module)
              } else if viewStore.id.contains("1year") {
                let price = formatPriceAsCurrency(currencyCode: viewStore.currencyCode, price: viewStore.price, divisor: 12)
                Text("\(price) / month", bundle: .module)
              }
            }
            .font(.callout)
            .fontWeight(.semibold)
          }
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 80)
        .background(Color(uiColor: UIColor.quaternarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
          viewStore.isSelected
            ? RoundedRectangle(cornerRadius: 12)
            .stroke(Color.purple, lineWidth: 2.0)
            : RoundedRectangle(cornerRadius: 12)
            .stroke(Color(uiColor: UIColor.opaqueSeparator), lineWidth: 1.0)
        )
        .overlay(alignment: .topTrailing) {
          if viewStore.isSelected {
            Image(systemName: "checkmark")
              .foregroundStyle(Color.black)
              .frame(width: 32, height: 32)
              .background(Color.purple)
              .clipShape(Circle())
              .offset(x: 16, y: -16)
          }
        }
        //      .overlay(alignment: .topLeading) {
        //        Text("most popular", bundle: .module)
        //          .padding(.vertical, 6)
        //          .padding(.horizontal, 12)
        //          .background(Color.purple)
        //          .font(.caption)
        //          .fontWeight(.heavy)
        //          .clipShape(RoundedRectangle(cornerRadius: 12))
        //      }
      }
      .buttonStyle(HoldDownButtonStyle())
    }
  }
}

