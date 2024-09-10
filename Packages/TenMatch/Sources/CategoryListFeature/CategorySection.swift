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
        .font(.system(.subheadline, design: .rounded, weight: .semibold))
        .foregroundStyle(Color.secondary)
        .padding(.horizontal, 16)

      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 8) {
          ForEachStore(
            store.scope(state: \.rows, action: \.rows),
            content: CategoryRowView.init(store:)
          )
        }
        .padding(.horizontal, 16)
      }
    }
  }
}
