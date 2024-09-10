import AVKit
import ComposableArchitecture
import HowToLocketLinkLogic
import Styleguide
import SwiftUI

public struct HowToLocketLinkView: View {
  @Bindable var store: StoreOf<HowToLocketLinkLogic>

  public init(store: StoreOf<HowToLocketLinkLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 36) {
      Text("In the Locket, select others and tap 'Copy' 📸.", bundle: .module)
        .font(.system(.title2, weight: .bold))

      VideoPlayer(player: store.player)
    }
    .padding(.top, 32)
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
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          Image(systemName: "xmark")
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(Color.white)
            .frame(width: 44, height: 44)
            .background(Color(uiColor: UIColor.quaternarySystemFill))
            .clipShape(Circle())
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    HowToLocketLinkView(
      store: .init(
        initialState: HowToLocketLinkLogic.State(),
        reducer: { HowToLocketLinkLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
