import ComposableArchitecture
import ProductPurchaseLogic
import StoreKit
import Styleguide
import SwiftUI

public struct ProductPurchaseContentRowView: View {
  @Bindable var store: StoreOf<ProductPurchaseContentRowLogic>

  public init(store: StoreOf<ProductPurchaseContentRowLogic>) {
    self.store = store
  }

  public var body: some View {
    Button {
      store.send(.rowButtonTapped, animation: .default)
    } label: {
      HStack(spacing: 0) {
        Text(store.period.displayName)
          .font(.headline)
          .fontWeight(.semibold)
          .frame(maxWidth: .infinity, alignment: .leading)

        VStack(alignment: .trailing, spacing: 4) {
          if let displayPrice = store.displayPrice {
            Text(displayPrice)
              .font(.callout)
              .fontWeight(.semibold)
              .foregroundStyle(Color.secondary)
              .overlay(alignment: .center) {
                Color.secondary
                  .frame(height: 2)
              }
          }

          Text(store.displayPriceWithPeriod)
            .font(.callout)
            .fontWeight(.semibold)
        }
      }
      .padding(.horizontal, 16)
      .frame(minHeight: 80)
      .background(Color(uiColor: UIColor.quaternarySystemFill))
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .overlay(
        store.isSelected
          ? RoundedRectangle(cornerRadius: 12)
          .stroke(Color.yellow, lineWidth: 2.0)
          : RoundedRectangle(cornerRadius: 12)
          .stroke(Color(uiColor: UIColor.opaqueSeparator), lineWidth: 1.0)
      )
      .overlay(alignment: .topTrailing) {
        if store.isSelected {
          Image(systemName: "checkmark")
            .foregroundStyle(Color.black)
            .frame(width: 32, height: 32)
            .background(Color.yellow)
            .clipShape(Circle())
            .offset(x: 8, y: -8)
        }
      }
      .overlay(alignment: .topLeading) {
        if store.isMostPopularFlag {
          Text("most popular", bundle: .module)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Color.yellow)
            .foregroundStyle(Color.black)
            .font(.caption)
            .fontWeight(.heavy)
            .cornerRadius(12, corners: [.topLeft, .bottomRight])
        }
      }
    }
    .buttonStyle(HoldDownButtonStyle())
  }
}
