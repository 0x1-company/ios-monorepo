import CategoryEmptyLogic
import ComposableArchitecture
import Styleguide
import SwiftUI

public struct CategoryEmptyView: View {
  @Bindable var store: StoreOf<CategoryEmptyLogic>

  public init(store: StoreOf<CategoryEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      Image(ImageResource.empty)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 120)

      Text("Looks like he's gone.", bundle: .module)
        .font(.system(.title3, design: .rounded, weight: .semibold))

      PrimaryButton(
        String(localized: "Swipe others", bundle: .module)
      ) {
        store.send(.emptyButtonTapped)
      }
    }
    .padding(.horizontal, 16)
    .multilineTextAlignment(.center)
  }
}

#Preview {
  NavigationStack {
    CategoryEmptyView(
      store: .init(
        initialState: CategoryEmptyLogic.State(),
        reducer: { CategoryEmptyLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
