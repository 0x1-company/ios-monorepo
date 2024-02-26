import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct DirectMessageListContentRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public let id: String
    let username: String

    public init(id: String, username: String) {
      self.id = id
      self.username = username
    }
  }

  public enum Action {
    case rowButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case showDirectMessage(_ username: String, _ targetUserId: String)
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .rowButtonTapped:
        let username = state.username
        let targetUserId = state.id
        return .send(.delegate(.showDirectMessage(username, targetUserId)))

      default:
        return .none
      }
    }
  }
}

public struct DirectMessageListContentRowView: View {
  let store: StoreOf<DirectMessageListContentRowLogic>

  public init(store: StoreOf<DirectMessageListContentRowLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        store.send(.rowButtonTapped)
      } label: {
        HStack(spacing: 8) {
          Color.blue
            .frame(width: 72, height: 72)
            .clipShape(Circle())
            .padding(.vertical, 8)

          VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
              Text(viewStore.username)
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
      .buttonStyle(HoldDownButtonStyle())
    }
  }
}
