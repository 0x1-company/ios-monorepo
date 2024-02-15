import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageListContentLogic {
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

public struct DirectMessageListContentView: View {
  let store: StoreOf<DirectMessageListContentLogic>

  public init(store: StoreOf<DirectMessageListContentLogic>) {
    self.store = store
  }

  public var body: some View {
    ForEach(0 ..< 10) { _ in
      HStack(spacing: 8) {
        Color.blue
          .frame(width: 72, height: 72)
          .clipShape(Circle())
          .padding(.vertical, 8)

        VStack(alignment: .leading, spacing: 0) {
          HStack(spacing: 0) {
            Text("yuka13")
              .font(.system(.subheadline, weight: .semibold))
              .frame(maxWidth: .infinity, alignment: .leading)

            Text("Let's Reply.", bundle: .module)
              .font(.system(.caption2, weight: .medium))
              .foregroundStyle(Color.black)
              .padding(.vertical, 3)
              .padding(.horizontal, 6)
              .background(Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 4))
          }

          Text("Hello")
            .lineLimit(1)
            .font(.body)
            .foregroundStyle(Color.secondary)
        }
      }
    }
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  NavigationStack {
    DirectMessageListContentView(
      store: .init(
        initialState: DirectMessageListContentLogic.State(),
        reducer: { DirectMessageListContentLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
