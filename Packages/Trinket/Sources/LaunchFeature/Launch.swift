import ComposableArchitecture
import LaunchLogic
import Styleguide
import SwiftUI

public struct LaunchView: View {
  let store: StoreOf<LaunchLogic>

  public init(store: StoreOf<LaunchLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Image(ImageResource.logo)
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color.yellow)
        .task { await store.send(.onTask).finish() }
        .overlay {
          if viewStore.isActivityIndicatorVisible {
            ProgressView()
              .tint(Color.white)
              .offset(y: 40)
          }
        }
    }
  }
}

#Preview {
  LaunchView(
    store: .init(
      initialState: LaunchLogic.State(),
      reducer: { LaunchLogic() }
    )
  )
}
