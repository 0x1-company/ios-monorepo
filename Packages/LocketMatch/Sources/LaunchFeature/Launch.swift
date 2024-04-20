import ComposableArchitecture
import LaunchLogic
import SwiftUI

public struct LaunchView: View {
  let store: StoreOf<LaunchLogic>

  public init(store: StoreOf<LaunchLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Image(ImageResource.cover)
        .resizable()
        .ignoresSafeArea()
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
