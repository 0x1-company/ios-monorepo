import ComposableArchitecture
import SwiftUI

@Reducer
public struct UnsentDirectMessageListContentLogic {
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

public struct UnsentDirectMessageListContentView: View {
  let store: StoreOf<UnsentDirectMessageListContentLogic>

  public init(store: StoreOf<UnsentDirectMessageListContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      ScrollView(.horizontal) {
        LazyHStack(spacing: 12) {
          ForEach(0 ..< 10) { _ in
            VStack(spacing: 12) {
              Color.red
                .frame(width: 90, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 6))

              Text("tomokisun")
                .font(.system(.subheadline, weight: .semibold))
            }
          }
        }
        .padding(.horizontal, 16)
      }
      .scrollIndicators(.hidden)
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  NavigationStack {
    UnsentDirectMessageListContentView(
      store: .init(
        initialState: UnsentDirectMessageListContentLogic.State(),
        reducer: { UnsentDirectMessageListContentLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
