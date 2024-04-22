import ComposableArchitecture
import DirectMessageLogic
import SwiftUI

public struct DirectMessageRowView: View {
  let store: StoreOf<DirectMessageRowLogic>

  public init(store: StoreOf<DirectMessageRowLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      let isAuthor = viewStore.message.isAuthor
      HStack(spacing: 0) {
        Text(viewStore.message.text)
          .padding(.vertical, 8)
          .padding(.horizontal, 12)
          .foregroundStyle(isAuthor ? Color.black : Color.primary)
          .background(isAuthor ? Color.white : Color(uiColor: UIColor.secondarySystemBackground))
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .padding(isAuthor ? Edge.Set.leading : Edge.Set.trailing, 100)
          .frame(maxWidth: .infinity, alignment: isAuthor ? Alignment.trailing : Alignment.leading)
      }
      .id(viewStore.id)
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
