import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct LaunchLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onTask
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none
      }
    }
  }
}

public struct LaunchView: View {
  let store: StoreOf<LaunchLogic>

  public init(store: StoreOf<LaunchLogic>) {
    self.store = store
  }

  public var body: some View {
    Image(ImageResource.cover)
      .resizable()
      .ignoresSafeArea()
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
