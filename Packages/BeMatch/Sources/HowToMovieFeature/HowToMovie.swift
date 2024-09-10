import AVKit
import ComposableArchitecture
import HowToMovieLogic
import Styleguide
import SwiftUI

public struct HowToMovieView: View {
  @Bindable var store: StoreOf<HowToMovieLogic>

  public init(store: StoreOf<HowToMovieLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 36) {
      Text(#"Press "Add to Photo" in memory and save it 📸."#, bundle: .module)
        .font(.system(.title3, weight: .semibold))

      VideoPlayer(player: store.player)

      Spacer()

      PrimaryButton(
        String(localized: "Next", bundle: .module)
      ) {
        store.send(.nextButtonTapped)
      }
    }
    .padding(.top, 24)
    .padding(.bottom, 16)
    .padding(.horizontal, 16)
    .background(Color.black)
    .foregroundStyle(Color.white)
    .multilineTextAlignment(.center)
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Image(ImageResource.logo)
      }
    }
  }
}

#Preview {
  NavigationStack {
    HowToMovieView(
      store: .init(
        initialState: HowToMovieLogic.State(),
        reducer: { HowToMovieLogic() }
      )
    )
  }
}
