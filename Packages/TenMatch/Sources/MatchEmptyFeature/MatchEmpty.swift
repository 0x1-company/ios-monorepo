import ComposableArchitecture
import MatchEmptyLogic
import Styleguide
import SwiftUI

public struct MatchEmptyView: View {
  let store: StoreOf<MatchEmptyLogic>

  public init(store: StoreOf<MatchEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      Image(ImageResource.matchEmpty)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 240)
        .clipped()

      VStack(spacing: 16) {
        Text("Let's swipe.", bundle: .module)
          .font(.system(.largeTitle, weight: .bold))

        Text("When you match with someone, their profile will appear here", bundle: .module)
          .font(.system(.callout, design: .rounded, weight: .semibold))

        PrimaryButton(
          String(localized: "Swipe", bundle: .module)
        ) {
          store.send(.swipeButtonTapped)
        }
      }
    }
    .padding(.top, 20)
    .multilineTextAlignment(.center)
    .foregroundStyle(Color.white)
  }
}

#Preview {
  MatchEmptyView(
    store: .init(
      initialState: MatchEmptyLogic.State(),
      reducer: { MatchEmptyLogic() }
    )
  )
}
