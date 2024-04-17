import AVKit
import BeRealSampleLogic
import ComposableArchitecture
import Styleguide
import SwiftUI

public struct BeRealSampleView: View {
  let store: StoreOf<BeRealSampleLogic>

  public init(store: StoreOf<BeRealSampleLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 36) {
        Text(#"Press "Add to Photo" in memory and save it 📸."#, bundle: .module)
          .font(.system(.title3, weight: .semibold))

        VideoPlayer(player: viewStore.player)

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
          Image(ImageResource.beMatch)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    BeRealSampleView(
      store: .init(
        initialState: BeRealSampleLogic.State(),
        reducer: { BeRealSampleLogic() }
      )
    )
  }
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
