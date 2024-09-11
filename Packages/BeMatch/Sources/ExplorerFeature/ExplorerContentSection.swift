import ComposableArchitecture
import ExplorerLogic
import SwiftUI

public struct ExplorerContentSectionView: View {
  @Bindable var store: StoreOf<ExplorerContentSectionLogic>

  public init(store: StoreOf<ExplorerContentSectionLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(store.explorer.title)
        .foregroundStyle(Color.secondary)
        .font(.system(.headline, weight: .semibold))
        .padding(.horizontal, 16)

      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 12) {
          ForEach(
            store.scope(state: \.rows, action: \.rows),
            id: \.state.id
          ) { store in
            ExplorerContentRowView(store: store)
          }
        }
        .padding(.horizontal, 16)
      }
    }
  }
}
