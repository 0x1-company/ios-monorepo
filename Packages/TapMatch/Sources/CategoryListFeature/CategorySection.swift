import CategoryListLogic
import ComposableArchitecture
import SwiftUI

public struct CategorySectionView: View {
  @Bindable var store: StoreOf<CategorySectionLogic>

  public init(store: StoreOf<CategorySectionLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(store.userCategory.title)
        .font(.system(.subheadline, weight: .semibold))
        .foregroundStyle(Color.secondary)
        .padding(.horizontal, 16)

      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 8) {
          ForEach(
            store.scope(state: \.rows, action: \.rows),
            id: \.state.id
          ) { store in
            CategoryRowView(store: store)
          }
        }
        .padding(.horizontal, 16)
      }
    }
  }
}
