import ComposableArchitecture
import ExplorerLogic
import Styleguide
import SwiftUI

public struct ExplorerEmptyView: View {
  let store: StoreOf<ExplorerEmptyLogic>

  public init(store: StoreOf<ExplorerEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      Image(ImageResource.empty)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 120)

      Text("Looks like he's gone.", bundle: .module)
        .font(.system(.title3, weight: .semibold))

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
    ExplorerEmptyView(
      store: .init(
        initialState: ExplorerEmptyLogic.State(),
        reducer: { ExplorerEmptyLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
