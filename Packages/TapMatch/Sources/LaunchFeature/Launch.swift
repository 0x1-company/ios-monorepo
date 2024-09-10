import ComposableArchitecture
import LaunchLogic
import Styleguide
import SwiftUI

public struct LaunchView: View {
  @Bindable var store: StoreOf<LaunchLogic>

  public init(store: StoreOf<LaunchLogic>) {
    self.store = store
  }

  public var body: some View {
    Image(ImageResource.logo)
      .aspectRatio(contentMode: .fit)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .ignoresSafeArea()
      .background(Color.black)
      .task { await store.send(.onTask).finish() }
      .overlay {
        if store.isActivityIndicatorVisible {
          ProgressView()
            .tint(Color.white)
            .offset(y: 104)
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
  .environment(\.colorScheme, ColorScheme.dark)
}
