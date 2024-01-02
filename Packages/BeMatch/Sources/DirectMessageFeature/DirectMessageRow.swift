import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable, Codable {
    let text: String

    public var id: String {
      text
    }

    public init(text: String) {
      self.text = text
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
        Text(viewStore.text)
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

#Preview {
  DirectMessageRowView(
    store: .init(
      initialState: DirectMessageRowLogic.State(
        text: "I live in San Francisco, where is Satoya?"
      ),
      reducer: { DirectMessageRowLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
}
