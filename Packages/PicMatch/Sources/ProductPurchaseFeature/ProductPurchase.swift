import ComposableArchitecture
import ProductPurchaseLogic
import SwiftUI

public struct ProductPurchaseView: View {
  @Bindable var store: StoreOf<ProductPurchaseLogic>

  public init(store: StoreOf<ProductPurchaseLogic>) {
    self.store = store
  }

  public var body: some View {
    Group {
      switch store.state {
      case .loading:
        ProgressView()
          .tint(Color.white)
      case .content:
        if let store = store.scope(state: \.content, action: \.content) {
          ProductPurchaseContentView(store: store)
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Image(ImageResource.logo)
      }
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          Image(systemName: "xmark")
            .font(.system(size: 12, weight: .regular))
            .frame(width: 32, height: 32)
            .foregroundStyle(Color.primary)
            .background(Color(uiColor: UIColor.quaternarySystemFill))
            .clipShape(Circle())
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    ProductPurchaseView(
      store: .init(
        initialState: ProductPurchaseLogic.State.loading,
        reducer: { ProductPurchaseLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
