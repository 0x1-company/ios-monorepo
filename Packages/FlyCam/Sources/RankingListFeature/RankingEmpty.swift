import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct RankingEmptyLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case takeButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case toCamera
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .takeButtonTapped:
        return .send(.delegate(.toCamera))

      case .delegate:
        return .none
      }
    }
  }
}

public struct RankingEmptyView: View {
  let store: StoreOf<RankingEmptyLogic>

  public init(store: StoreOf<RankingEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      Text("No one seems to have posted a FlyCam yet. Be the first one.", bundle: .module)

      PrimaryButton(
        String(localized: "Take your FlyCam", bundle: .module)
      ) {
        store.send(.takeButtonTapped)
      }
    }
    .padding(.horizontal, 24)
    .multilineTextAlignment(.center)
  }
}

#Preview {
  RankingEmptyView(
    store: .init(
      initialState: RankingEmptyLogic.State(),
      reducer: { RankingEmptyLogic() }
    )
  )
}
