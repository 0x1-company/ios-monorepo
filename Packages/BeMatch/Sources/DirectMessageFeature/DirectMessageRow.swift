import BeMatch
import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    let message: BeMatch.MessageRow

    public var id: String {
      message.id
    }

    public init(message: BeMatch.MessageRow) {
      self.message = message
    }
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

public struct DirectMessageRowView: View {
  let store: StoreOf<DirectMessageRowLogic>

  public init(store: StoreOf<DirectMessageRowLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      if viewStore.message.isAuthor {
        HStack(spacing: 0) {
          Text(viewStore.message.text)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .foregroundStyle(Color.black)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.leading, 100)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .listRowSeparator(.hidden)
      } else {
        HStack(spacing: 0) {
          Text(viewStore.message.text)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .foregroundStyle(Color.primary)
            .background(Color(uiColor: UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.trailing, 100)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .listRowSeparator(.hidden)
      }
    }
  }
}
