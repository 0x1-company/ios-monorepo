import ComposableArchitecture
import ProductPurchaseLogic
import SwiftUI
import Styleguide

public struct ProductPurchaseContentRowView: View {
  let store: StoreOf<ProductPurchaseContentRowLogic>

  public init(store: StoreOf<ProductPurchaseContentRowLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        store.send(.rowButtonTapped, animation: .default)
      } label: {
        HStack(spacing: 0) {
          Text(viewStore.displayName)
            .font(.title)
            .fontWeight(.bold)
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

            Text("$6.99 / week")
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

#Preview {
  NavigationStack {
    VStack(spacing: 16) {
      ProductPurchaseContentRowView(
        store: .init(
          initialState: ProductPurchaseContentRowLogic.State(
            id: "1",
            displayPrice: "$27.96",
            displayName: "1 week",
            isSelected: false
          ),
          reducer: { ProductPurchaseContentRowLogic() }
        )
      )

      ProductPurchaseContentRowView(
        store: .init(
          initialState: ProductPurchaseContentRowLogic.State(
            id: "2",
            displayPrice: "$27.96",
            displayName: "1 week",
            isSelected: true
          ),
          reducer: { ProductPurchaseContentRowLogic() }
        )
      )
    }
    .padding(.horizontal, 16)
  }
  .environment(\.colorScheme, .dark)
}
