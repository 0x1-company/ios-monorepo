import BeMatch
import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageRowLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    let message: BeMatch.MessageRow

    public var id: String {
      message.id
    }

    public init(message: BeMatch.MessageRow) {
      self.message = message
    }
  }

  public enum Action {
    case reportButtonTapped
  }

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case .reportButtonTapped:
        return .none
      }
    }
  }
}

public struct DirectMessageRowView: View {
  @Perception.Bindable var store: StoreOf<DirectMessageRowLogic>

  public init(store: StoreOf<DirectMessageRowLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      let isAuthor = store.message.isAuthor
      HStack(spacing: 0) {
        Text(store.message.text)
          .padding(.vertical, 8)
          .padding(.horizontal, 12)
          .foregroundStyle(isAuthor ? Color.black : Color.primary)
          .background(isAuthor ? Color.white : Color(uiColor: UIColor.secondarySystemBackground))
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .padding(isAuthor ? Edge.Set.leading : Edge.Set.trailing, 100)
          .frame(maxWidth: .infinity, alignment: isAuthor ? Alignment.trailing : Alignment.leading)
      }
      .id(store.id)
      .listRowSeparator(.hidden)
      .contextMenu {
        Button {
          store.send(.reportButtonTapped)
        } label: {
          Label {
            Text("Report", bundle: .module)
          } icon: {
            Image(systemName: "exclamationmark.triangle")
          }
        }
      }
    }
  }
}
