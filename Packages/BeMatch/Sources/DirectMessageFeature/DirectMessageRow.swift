import BeMatch
import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    let data: BeMatch.MessageRow

    public var id: String {
      data.id
    }

    public init(data: BeMatch.MessageRow) {
      self.data = data
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
      HStack(spacing: 0) {
        Text(viewStore.data.text)
          .padding(.vertical, 8)
          .padding(.horizontal, 12)
          .foregroundStyle(Color.black)
          .background(Color.white)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .padding(.leading, 100)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .padding(.horizontal, 16)
      .listRowSeparator(.hidden)
    }
  }
}
