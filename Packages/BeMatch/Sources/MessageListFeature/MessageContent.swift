import ComposableArchitecture
import SwiftUI

@Reducer
public struct MessageContentLogic {
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

public struct MessageContentView: View {
  let store: StoreOf<MessageContentLogic>

  public init(store: StoreOf<MessageContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      ScrollView(.vertical) {
        LazyVStack(alignment: .leading, spacing: 32) {
          VStack(alignment: .leading, spacing: 8) {
            Text("Recent match", bundle: .module)
              .font(.system(.callout, weight: .semibold))
              .padding(.horizontal, 16)

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
          }

          LazyVStack(alignment: .leading, spacing: 8) {
            Text("Message", bundle: .module)
              .font(.system(.callout, weight: .semibold))

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

                    Text("Let's Reply.")
                      .font(.caption2)
                      .foregroundStyle(Color.black)
                      .padding(.vertical, 3)
                      .padding(.horizontal, 6)
                      .background(Color.white)
                      .clipShape(RoundedRectangle(cornerRadius: 4))
                  }

                  Text("Hello")
                    .font(.body)
                    .foregroundStyle(Color.secondary)
                }
              }
            }
          }
          .padding(.horizontal, 16)
        }
      }
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  NavigationStack {
    MessageContentView(
      store: .init(
        initialState: MessageContentLogic.State(),
        reducer: { MessageContentLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
