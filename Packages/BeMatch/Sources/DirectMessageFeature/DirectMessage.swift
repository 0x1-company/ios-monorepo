import AnalyticsClient
import ComposableArchitecture
import FeedbackGeneratorClient
import SwiftUI

@Reducer
public struct DirectMessageLogic {
  public init() {}

  public struct State: Equatable {
    let username: String

    var rows: IdentifiedArrayOf<DirectMessageRowLogic.State> = []
    @BindingState var message = String()
    var isDisabled = true

    public init(username: String) {
      self.username = username
      let decoder = JSONDecoder()
      if let data = UserDefaults.standard.data(forKey: "messages-\(username)") {
        if let rows = try? decoder.decode([DirectMessageRowLogic.State].self, from: data) {
          self.rows = .init(uniqueElements: rows)
        }
      }
    }
  }

  public enum Action: BindableAction {
    case onTask
    case onAppear
    case closeButtonTapped
    case sendButtonTapped
    case rows(IdentifiedActionOf<DirectMessageRowLogic>)
    case binding(BindingAction<State>)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .onAppear:
        analytics.logScreen(screenName: "DirectMessage", of: self)
        return .none

      case .closeButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      case .sendButtonTapped:
        let encoder = JSONEncoder()
        state.rows.append(
          DirectMessageRowLogic.State(text: state.message)
        )
        if let data = try? encoder.encode(state.rows.elements) {
          UserDefaults.standard.set(data, forKey: "messages-\(state.username)")
        }
        analytics.logEvent(name: "send_message", parameters: [
          "text": state.message,
        ])
        state.message.removeAll()
        state.isDisabled = true
        return .none

      case .binding:
        state.isDisabled = state.message.isEmpty
        return .none

      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      DirectMessageRowLogic()
    }
  }
}

public struct DirectMessageView: View {
  let store: StoreOf<DirectMessageLogic>

  public init(store: StoreOf<DirectMessageLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        List {
          ForEachStore(
            store.scope(state: \.rows, action: \.rows),
            content: DirectMessageRowView.init(store:)
          )
        }
        .listStyle(PlainListStyle())

        HStack(spacing: 8) {
          TextField(
            text: viewStore.$message,
            axis: .vertical
          ) {
            Text("Message", bundle: .module)
          }
          .lineLimit(1 ... 10)
          .padding(.vertical, 8)
          .padding(.horizontal, 16)
          .tint(Color.white)
          .background(Color(uiColor: UIColor.tertiarySystemBackground))
          .clipShape(RoundedRectangle(cornerRadius: 26))

          Button {
            store.send(.sendButtonTapped)
          } label: {
            Image(systemName: "paperplane.fill")
              .foregroundStyle(Color.primary)
          }
          .disabled(viewStore.isDisabled)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
      }
      .navigationBarTitleDisplayMode(.inline)
      .onAppear { store.send(.onAppear) }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text(viewStore.username)
            .font(.system(.callout, weight: .semibold))
        }

        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "chevron.down")
              .foregroundStyle(Color.white)
              .font(.system(.headline, weight: .semibold))
          }
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    DirectMessageView(
      store: .init(
        initialState: DirectMessageLogic.State(
          username: "tomokisun"
        ),
        reducer: { DirectMessageLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
