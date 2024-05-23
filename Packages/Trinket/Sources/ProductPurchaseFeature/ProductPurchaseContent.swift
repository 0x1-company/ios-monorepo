import ComposableArchitecture
import ProductPurchaseLogic
import StoreKit
import Styleguide
import SwiftUI

public struct ProductPurchaseContentView: View {
  let store: StoreOf<ProductPurchaseContentLogic>

  public init(store: StoreOf<ProductPurchaseContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack(alignment: .top) {
        Color.yellow
          .frame(width: 190, height: 190)
          .clipShape(Circle())
          .offset(y: -190)
          .blur(radius: 64)

        VStack(spacing: 0) {
          ScrollView(.vertical) {
            VStack(spacing: 16) {
              Text("Premium Plan", bundle: .module)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .overlay(
                  Capsule()
                    .stroke(Color.white, lineWidth: 1)
                )

              Text("See who likes you", bundle: .module)
                .font(.title2)
                .fontWeight(.bold)

              ForEachStore(
                store.scope(state: \.rows, action: \.rows),
                content: ProductPurchaseContentRowView.init(store:)
              )

              Text("Recurring billing. You can cancel at any time. Your payment will be charged to your iTunes account and will auto-renew until you cancel in the iTunes Store settings. By tapping Unlock, you agree to the Terms of Service and auto-renewal.", bundle: .module)
                .font(.caption)
                .foregroundStyle(Color(uiColor: UIColor.tertiaryLabel))
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
          }

          PrimaryButton(
            String(localized: "Next", bundle: .module),
            isLoading: viewStore.isActivityIndicatorVisible,
            isDisabled: viewStore.isActivityIndicatorVisible
          ) {
            store.send(.purchaseButtonTapped, animation: .default)
          }
          .padding(.bottom, 16)
          .padding(.horizontal, 16)
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .overlay {
        if viewStore.isActivityIndicatorVisible {
          ProgressView()
            .tint(Color.white)
            .progressViewStyle(CircularProgressViewStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.6))
        }
      }
      .alert(store: store.scope(state: \.$destination.alert, action: \.destination.alert))
    }
  }
}

#Preview {
  NavigationStack {
    ProductPurchaseContentView(
      store: .init(
        initialState: ProductPurchaseContentLogic.State(
          appAccountToken: UUID(),
          products: []
        ),
        reducer: { ProductPurchaseContentLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
